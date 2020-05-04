//
//  ZuumScreensaverView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/3/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import ScreenSaver

final class ZuumScreensaverView: ScreenSaverView {
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        addYoutube()
        
        videoGridViewController?.view.frame = self.bounds
    }
    
    var videoGridViewController: VideoGridViewController?
    private func addYoutube() {
        guard videoGridViewController == nil else { return }
        
        let vc = VideoGridViewController()
        addSubview(vc.view)
        
        self.videoGridViewController = vc
    }
    
    
    override var acceptsFirstResponder: Bool { return true }

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        if let characters = event.characters {
            videoGridViewController?.blockbuster.didType(characters)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        let location = event.locationInWindow
        videoGridViewController?.blockbuster.didClick(location)
    }

    override var hasConfigureSheet: Bool {
        return true
    }

    var optionsViewController: OptionsViewController?
    override var configureSheet: NSWindow? {
        get {
            let sheetFrame = NSRect(x: 0, y: 0, width: 500, height: 300)
            let vc = OptionsViewController()
            vc.view.frame = sheetFrame
            optionsViewController = vc
            
            let window = NSWindow(
                contentRect: sheetFrame,
                styleMask: [.fullSizeContentView],
                backing: .buffered, defer: false)
            window.center()
            window.setFrameAutosaveName("Configure Sheet")
            window.contentView = vc.view
            
            return window
        }
    }
}
