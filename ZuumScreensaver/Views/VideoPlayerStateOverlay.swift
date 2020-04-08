//
//  VideoPlayerStateOverlay.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/8/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import AppKit

final class VideoPlayerStateOverlay: NSView {
    enum State {
        case none,
            loading,
            paused(_ message: String?),
            lost(_ message: String?)
    }
    
    var state = State.none {
        didSet {
            var progressIndicatorEnabled: Bool
            var warningLabelEnabled: Bool
            var theMessage: String?
            
            switch state {
                case .none:
                    progressIndicatorEnabled = false
                    warningLabelEnabled = false
                    theMessage = nil
                
                case .loading:
                    progressIndicatorEnabled = true
                    warningLabelEnabled = false
                    theMessage = nil

                case .paused(message: let message):
                    progressIndicatorEnabled = true
                    warningLabelEnabled = false
                    theMessage = message
                
                case .lost(message: let message):
                    progressIndicatorEnabled = false
                    warningLabelEnabled = true
                    theMessage = message
            }
            
            toggleMessageLabel(message: theMessage)
            toggleWarningLabel(enabled: warningLabelEnabled)
            toggleProgressIndicator(enabled: progressIndicatorEnabled)
        }
    }
    
    private let messageLabel: NSTextView = {
        let tv = NSTextView()
        tv.backgroundColor = .black
        tv.textColor = .white
        tv.font = .systemFont(ofSize: 15)
        tv.alignment = .center
        return tv
    }()
    private let messageLabelWrapper: NSView = {
        let nsv = NSView()
        nsv.wantsLayer = true
        nsv.layer?.backgroundColor = NSColor.black.cgColor
        return nsv
    }()

    private let warningLabel: NSTextView = {
        let wl = NSTextView()
        wl.string = "⚠️"
        wl.backgroundColor = .clear
        wl.font = .systemFont(ofSize: 50)
        wl.alignment = .center
        return wl
    }()
    
    let progressIndicator: NSProgressIndicator = {
        var progressIndicator = NSProgressIndicator()
        progressIndicator.isIndeterminate = true
        progressIndicator.style = .spinning
        return progressIndicator
    }()
    
    private func toggleMessageLabel(message: String?) {
        if let message = message {
            messageLabel.string = message
            messageLabelWrapper.addSubview(messageLabel)
            addSubview(messageLabelWrapper)
        } else {
            messageLabelWrapper.removeFromSuperview()
        }
    }
    
    func toggleWarningLabel(enabled: Bool) {
        if enabled {
            addSubview(warningLabel)
        } else {
            warningLabel.removeFromSuperview()
        }
    }
    
    func toggleProgressIndicator(enabled: Bool) {
        if enabled {
            progressIndicator.startAnimation(nil)
            addSubview(progressIndicator)
        } else {
            progressIndicator.stopAnimation(nil)
            progressIndicator.removeFromSuperview()
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        needsLayout = true
    }

    override func layout() {
        super.layout()
        
        var frame = progressIndicator.frame
        frame.size = CGSize(width: 25, height: 25)
        frame.origin.x = (bounds.width - frame.width) / 2.0
        frame.origin.y = (bounds.height - frame.height) / 2.0
        progressIndicator.frame = frame
        
        frame.size = CGSize(width: 60, height: 60)
        frame.origin.x = (bounds.width - frame.width) / 2.0
        frame.origin.y = (bounds.height - frame.height) / 2.0
        warningLabel.frame = frame
        
        frame.size = CGSize(width: bounds.width, height: 50)
        frame.origin.x = 0
        frame.origin.y = 0
        messageLabelWrapper.frame = frame

        frame.size = CGSize(width: messageLabelWrapper.bounds.width, height: 20)
        frame.origin.x = 0
        frame.origin.y = (messageLabelWrapper.bounds.height - frame.height) / 2.0
        messageLabel.frame = frame

    }
}
