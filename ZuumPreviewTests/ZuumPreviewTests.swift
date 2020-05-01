//
//  ZuumPreviewTests.swift
//  ZuumPreviewTests
//
//  Created by Robert Tolar Haining on 4/3/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest
@testable import ZuumPreview

class ZuumPreviewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func newConfig() -> Config {
        return Config(minVideos: 5, maxVideos: 10, connectionErrorMessages: nil, version: nil, upgradeMessage: nil, videos: ["https://example.com/everyone"], deafVideos: ["https://example.com/deaf"], hearingVideos: ["https://example.com/hearing"])
    }

    func testVideoSetEveryone() throws {
        DefaultsHelper.savePreferredVideoSet(.everyone)
        XCTAssert(DefaultsHelper.getPreferredVideoSet() == .everyone)
        
        let config = newConfig()
        XCTAssert(config.videoURLS[0] == URL(string: "https://example.com/everyone"))
    }
    func testVideoSetHearing() throws {
        DefaultsHelper.savePreferredVideoSet(.hearing)
        XCTAssert(DefaultsHelper.getPreferredVideoSet() == .hearing)

        let config = newConfig()
        XCTAssert(config.videoURLS[0] == URL(string: "https://example.com/hearing"))
    }
    func testVideoSetDeaf() throws {
        DefaultsHelper.savePreferredVideoSet(.deaf)
        XCTAssert(DefaultsHelper.getPreferredVideoSet() == .deaf)
        
        let config = newConfig()
        XCTAssert(config.videoURLS[0] == URL(string: "https://example.com/deaf"))
    }



}
