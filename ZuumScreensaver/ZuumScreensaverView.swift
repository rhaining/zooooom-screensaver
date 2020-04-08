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
        if let characters = event.characters {
            videoGridViewController?.blockbuster.didType(characters)
        }
    }
}
