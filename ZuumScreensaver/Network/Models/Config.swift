//
//  Config.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

struct Config: Codable {
    let minVideos: Int?
    var maxVideos: Int?
    
    let connectionErrorMessages: [String]?
    let version: String?
    let upgradeMessage: String?
    
    let videos: [String]
    let deafVideos: [String]
    
    var videoURLS: [URL] {
        return preferredVideoSetURLStrings.compactMap { (urlStr) -> URL? in
            return URL(string: urlStr) ?? nil
        }
    }
    
    private var preferredVideoSetURLStrings: [String] {
        switch DefaultsHelper.getPreferredVideoSet() {
            case .everyone:
                return videos
            
            case .deaf:
                return deafVideos
        }
    }
    
    func randomErrorMessage() -> String? {
        return connectionErrorMessages?.randomElement()
    }
}
