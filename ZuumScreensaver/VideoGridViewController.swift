//
//  VideoViewController.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI

final class VideoGridViewController: NSViewController {
    let blockbuster = Blockbuster()

    private var overlay: NSHostingView<ConnectingView>?
    private var errorHostingView: NSHostingView<ErrorView>?

    private var menuBarHostingView: NSHostingView<MenuBarView>?
    private var toolbarHostingView: NSHostingView<ToolbarView>?
    
    private var videoGridView: NSView?

    init() {
        super.init(nibName: nil, bundle: nil)
        blockbuster.delegate = self
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = NSView()        
        
        let videoGridView = NSView()
        view.addSubview(videoGridView)
        self.videoGridView = videoGridView
        
        let toolbar = ToolbarView(blockbuster: blockbuster)
        let toolbarHostingView = NSHostingView(rootView: toolbar)
        view.addSubview(toolbarHostingView)
        self.toolbarHostingView = toolbarHostingView

        let menubar = MenuBarView(blockbuster: blockbuster)
        let menuBarHostingView = NSHostingView(rootView: menubar)
        view.addSubview(menuBarHostingView)
        self.menuBarHostingView = menuBarHostingView

        addOverlay()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        guard let toolbarHostingView = toolbarHostingView,
            let menuBarHostingView = menuBarHostingView,
            let videoGridView = videoGridView
            else {
                return
                
        }
        
        overlay?.frame = view.bounds
        
        toolbarHostingView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 55)
        menuBarHostingView.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 35)

        videoGridView.frame = CGRect(x: 0,
                                     y: toolbarHostingView.bounds.height,
                                     width: view.bounds.width,
                                     height: view.bounds.height - (toolbarHostingView.bounds.height + menuBarHostingView.bounds.height))
        
        layoutVideos()
    }
    
    private func layoutVideos() {
        guard blockbuster.videoViews.count > 0,
            let videoGridView = videoGridView else { return }
        
        let numberOfVideos = blockbuster.videoViews.count
        let maxVideosPerRow = ceil( sqrt( Double(numberOfVideos) ) )
        let numberOfRows = Int( ceil( Double(numberOfVideos) / maxVideosPerRow ) )
        let countPerRow = Int( ceil( Double(numberOfVideos) / Double(numberOfRows) ) )
        let padding = CGFloat(5)
        
        let height = videoGridView.bounds.height / (CGFloat(numberOfRows) * 1.1)
        let width = videoGridView.bounds.width / (CGFloat(countPerRow) * 1.1)
        
        var xOffset = videoGridView.bounds.width
        xOffset -= width * CGFloat(countPerRow)
        xOffset -= padding * CGFloat(countPerRow-1)
        xOffset /= 2.0
        
        var yOffset = videoGridView.bounds.height
        yOffset -= height * CGFloat(numberOfRows)
        yOffset -= padding * CGFloat(numberOfRows-1)
        yOffset /= 2.0

        var hasUpdatedXOffsetForLastRow = false
        for row in 0..<numberOfRows {
            for col in 0..<countPerRow {
                let videoViewIdx = row * countPerRow + col
                if videoViewIdx >= numberOfVideos {
                    break
                }
                
                //fix xOffset so last row of videos is centered in the grid.
                if row > 0 && row == numberOfRows-1 && !hasUpdatedXOffsetForLastRow {
                    //last row
                    let countOnLastRow = numberOfVideos % Int(maxVideosPerRow)
                    if countOnLastRow > 0 && countOnLastRow < countPerRow {
                        let delta = countPerRow - countOnLastRow
                        xOffset += ((padding * CGFloat(delta)) + (width * CGFloat(delta))) / 2.0
                        hasUpdatedXOffsetForLastRow = true
                    }
                }
                
                let videoView = blockbuster.videoViews[videoViewIdx]
                var frame = CGRect(x: 0, y: 0, width: width, height: height)
                frame.origin.x = xOffset + (padding * CGFloat(col)) + (width * CGFloat(col))
                frame.origin.y = videoGridView.bounds.height - height - (yOffset + (padding * CGFloat(row)) + (height * CGFloat(row)))
                videoView.frame = frame
            }
        }
    }
    
    private func addOverlay() {
        let connectingView = ConnectingView()
        let overlay = NSHostingView(rootView: connectingView)
        overlay.wantsLayer = true
        overlay.layer?.backgroundColor = .init(gray: 0.95, alpha: 1)
        view.addSubview(overlay)
        
        self.overlay = overlay
    }
    
    private func removeOverlay() {
        NSAnimationContext.runAnimationGroup{ _ in
            NSAnimationContext.current.duration = 0.2
            overlay?.animator().removeFromSuperview()
        }
    }
}

extension VideoGridViewController: BlockbusterDelegate {
    func blockbusterIsReady() {
        removeOverlay()
    }
    
    func addVideoView(_ videoView: VideoPlayerView) {
        if let overlay = overlay {
            videoGridView?.addSubview(videoView, positioned: .below, relativeTo: overlay)
        } else {
            videoGridView?.addSubview(videoView)
        }
        layoutVideos()
    }
    
    func removeVideoView(_ videoView: VideoPlayerView) {
        videoView.removeFromSuperview()
        layoutVideos()
    }
    
    func blockbusterIsFetchingConfig() {
        NSAnimationContext.runAnimationGroup{ _ in
            NSAnimationContext.current.duration = 0.2
            errorHostingView?.removeFromSuperview()
            errorHostingView = nil
        }
    }
    
    func errorRetrievingConfig(_ error: Error?) {
        let errorView = ErrorView(errorText: error?.localizedDescription)
        let errorHostingView = NSHostingView(rootView: errorView)
        errorHostingView.wantsLayer = true
        errorHostingView.layer?.backgroundColor = .init(gray: 1, alpha: 1)
        errorHostingView.frame = view.bounds
        view.addSubview(errorHostingView)
        
        self.errorHostingView = errorHostingView

    }
}
