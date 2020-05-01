//
//  OptionsViewController.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/15/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit
import SwiftUI


final class OptionsViewController: NSViewController {
    var optionsView: OptionsView?
    
    override func loadView() {
        let preferredVideoSet = DefaultsHelper.getPreferredVideoSet()
        let preferredVideoSetIndex = VideoSet.allCases.firstIndex(of: preferredVideoSet) ?? 0
        let optionsView = OptionsView(selectedVideoSetIndex: preferredVideoSetIndex,
                                      save: closeOptions)
        view = NSHostingView(rootView: optionsView)
        self.optionsView =  optionsView
    }
    

    func closeOptions(_ selectedVideoSetIndex: Int) {
        guard let window = view.window else { return }
        
        let selectedVideoSet = VideoSet.allCases[selectedVideoSetIndex]
        DefaultsHelper.savePreferredVideoSet(selectedVideoSet)
        
        window.endSheet(window)
    }
}

struct DefaultsHelper {
    private static let key = "ZooooomPreferredVideoSet"
    static func savePreferredVideoSet(_ videoSet: VideoSet) {
        UserDefaults.standard.set(videoSet.rawValue, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getPreferredVideoSet() -> VideoSet {
        if let videoSetString = UserDefaults.standard.string(forKey: key),
            let videoSet = VideoSet(rawValue: videoSetString) {
            return videoSet
        } else {
            return VideoSet.everyone
        }
    }
}
