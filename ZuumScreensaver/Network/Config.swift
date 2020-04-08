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
    let maxVideos: Int?
    
    let connectionErrorMessages: [String]?
    let version: String?
    let upgradeMessage: String?
    
    let videos: [String]
    var videoURLS: [URL] {
        return videos.compactMap { (urlStr) -> URL? in
            return URL(string: urlStr) ?? nil
        }
    }
    
    func randomErrorMessage() -> String? {
        return connectionErrorMessages?.randomElement()
    }
}
