//
//  AppDelegate.swift
//  ZuumPreview
//
//  Created by Robert Tolar Haining on 4/3/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var previewViewController: PreviewScreensaverViewController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let previewViewController = PreviewScreensaverViewController()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = previewViewController.view
        window.makeKeyAndOrderFront(nil)
        
        self.previewViewController = previewViewController
        
        previewViewController.becomeFirstResponder()
    }
}
