//
//  VersionHelper.swift
//  FloatingHeads
//
//  Created by Robert Tolar Haining on 1/14/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

struct VersionHelper {
    static var installedScreensaverVersion: String? {
        return Bundle(for: ZuumScreensaverView.self).object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    let publishedScreensaverVersion: String
    let installedScreensaverVersion: String
    
    init?(publishedScreensaverVersion: String?) {
        guard let publishedScreensaverVersion = publishedScreensaverVersion,
                let installedScreensaverVersion = VersionHelper.installedScreensaverVersion
                else { return nil }
        
        self.publishedScreensaverVersion = publishedScreensaverVersion
        self.installedScreensaverVersion = installedScreensaverVersion
    }
    
    func canUpgrade() -> Bool {
        return (installedScreensaverVersion.compare(publishedScreensaverVersion, options: .numeric) == .orderedAscending)
    }
}
