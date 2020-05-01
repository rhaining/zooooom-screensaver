//
//  PreviewScreensaverViewController.swift
//  ScreensaverPreview
//
//  Created by Robert Tolar Haining on 3/23/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import SwiftUI

class PreviewScreensaverViewController: NSViewController {
    var screensaverView: ZuumScreensaverView? = nil
    
    var timer: Timer? = nil
    
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                if timer == nil {
                    timer = Timer.scheduledTimer(withTimeInterval: screensaverView?.animationTimeInterval ?? 1, repeats: true) { [weak self] (_) in
                        self?.animate()
                    }
                }
            } else {
                if let timer = timer {
                    timer.invalidate()
                    self.timer = nil
                }
            }
        }
    }
    
    override func loadView() {
        screensaverView = ZuumScreensaverView(frame: CGRect.zero, isPreview: true)
        self.view = screensaverView ?? NSView()
        
        becomeFirstResponder()
    }
        
    override func viewDidAppear() {
        super.viewDidAppear()
        
        isAnimating = true
        
        loadOptionsWindow()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        isAnimating = false
    }
    
    func animate() {
        if isAnimating, let screensaverView = screensaverView {
            screensaverView.animateOneFrame()
        }
    }
    
    func loadOptionsWindow() {
        screensaverView?.configureSheet?.makeKeyAndOrderFront(nil)
    }
}
