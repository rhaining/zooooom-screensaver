//
//  Blockbuster.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

protocol BlockbusterDelegate {
    func blockbusterIsReady()
    func addVideoView(_ videoView: VideoPlayerView)
    func removeVideoView(_ videoView: VideoPlayerView)
    
    func blockbusterIsFetchingConfig()
    func errorRetrievingConfig(_ error: Error?)
}

final class Blockbuster: ObservableObject {
    private struct VideoTimes {
        static let timeToRefetchConfig = 10
        static let maxTimeToRefetchConfig = 300
        static let timeRangeToRandom = 1..<10
        static let delayRangeAfterPause = 1..<10
        static let delayRangeAfterLostConnection = 2..<4
        static let delayRangeAfterRestoredConnection = 4..<8
    }

    var delegate: BlockbusterDelegate?

    private var numberOfConfigFetchAttempts = 0
    private var config: Config? = nil {
        didSet {
            if let config = config {
                allVideoURLs = Set(config.videoURLS)
            }
        }
    }
    @Published var upgradeMessage: String? = nil
    
    private var allVideoURLs: Set<URL>? = nil
    var videoViews: [VideoPlayerView] = [] {
        didSet {
            currentNumberOfVideos = videoViews.count
        }
    }

    @Published var currentNumberOfVideos: Int = 0
    private var currentVideoURLs: Set<URL> { return Set(videoViews.map{ return $0.url }) }

    private var minVideosToShow: Int { return config?.minVideos ?? 0 }
    private var maxVideosToShow: Int { return config?.maxVideos ?? NSIntegerMax }

    init() {
        fetchConfig()
    }
    
    private func fetchConfig() {
        delegate?.blockbusterIsFetchingConfig()
        
        ConfigFetcher.fetch { [weak self] (config, error) in
            if let config = config {
                self?.config = config
                self?.setupInitialVideos()
                self?.checkOnUpgrade()
            } else {
                self?.delegate?.errorRetrievingConfig(error)
                self?.refetchConfigAfterDelay()
            }
        }
    }
    private func refetchConfigAfterDelay() {
        numberOfConfigFetchAttempts += 1
        let secondsToRefetch = min(numberOfConfigFetchAttempts * VideoTimes.timeToRefetchConfig, VideoTimes.maxTimeToRefetchConfig)
        
        NSLog("secondsToRefetch: \(secondsToRefetch)")
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(secondsToRefetch)) { [weak self] in
            self?.fetchConfig()
        }
    }
    
    private func setupInitialVideos() {
        for _ in 0..<2 {
            addAVideo()
        }
    }
    
    private var hasStarted = false
    fileprivate func weCanStartNow() {
        guard !hasStarted else { return }
        
        delegate?.blockbusterIsReady()
        enableRandomness()
        
        hasStarted = true
    }
    
    private var cancelRandom = false
    private func enableRandomness() {
        let randomDelay = Int.random(in: VideoTimes.timeRangeToRandom)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(randomDelay)) { [weak self] in
            self?.performRandomAction()
        }
    }
    private func toggleRandom(canceled: Bool) {
        cancelRandom = canceled
    }
    
    private func performRandomAction() {
        guard !cancelRandom else { return }
        
        let choice = Dice.roll()
        switch choice {
            case .add:
                addAVideo()
            
            case .remove:
                removeAVideo()
            
            case .pause:
                pauseAVideo()
            
            case .stay:
                //do nothing.
                break
            
            case .loseConnection:
                loseAConnection()
        }
        
        enableRandomness()
    }
    
    private func addThisVideo(with url: URL) {
        let videoView = VideoPlayerView(url: url)
        videoView.delegate = self
        videoViews.append(videoView)
        
        let randomPercent = Double.random(in: 0..<1)
        videoView.play(to: randomPercent)
        
        delegate?.addVideoView(videoView)
    }
    
    private func addAVideo() {
        guard let allVideoURLs = allVideoURLs,
            videoViews.count < maxVideosToShow,
            videoViews.count < allVideoURLs.count else {
                return
        }
        
        let remainingVideoURLs = allVideoURLs.subtracting(currentVideoURLs)
        if let url = remainingVideoURLs.randomElement() {
            addThisVideo(with: url)
        }
    }
    
    private func removeThisVideo(videoView: VideoPlayerView) {
        if let videoIndex = videoViews.firstIndex(of: videoView) {
            videoViews.remove(at: videoIndex)
        }
        
        delegate?.removeVideoView(videoView)
    }
    
    private func removeAVideo() {
        guard videoViews.count > minVideosToShow else { return }
        
        if let videoView = videoViews.randomElement() {
            removeThisVideo(videoView: videoView)
        }
    }
    
    private func pauseAVideo() {
        if let videoView = videoViews.randomElement() {
            videoView.pause(message: config?.randomErrorMessage())
            let randomDelay = Int.random(in: VideoTimes.delayRangeAfterPause)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(randomDelay)) { [weak videoView] in
                videoView?.play()
            }
        }
    }
    
    private func loseAConnection() {
        if let videoView = videoViews.randomElement() {
            videoView.pause(message: config?.randomErrorMessage(),
                            warning: true)
            
            let randomDelay = Int.random(in: VideoTimes.delayRangeAfterLostConnection)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(randomDelay)) { [weak videoView, weak self] in
                guard let videoView = videoView else { return }
                
                self?.addThisVideo(with: videoView.url)
                
                let randomDelay = Int.random(in: VideoTimes.delayRangeAfterRestoredConnection)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(randomDelay)) { [weak videoView, weak self] in
                    guard let videoView = videoView else { return }
                    
                    self?.removeThisVideo(videoView: videoView)
                }
            }
        }
    }
    
    private func checkOnUpgrade() {        
        if let versionHelper = VersionHelper(publishedScreensaverVersion: config?.version),
            versionHelper.canUpgrade() {
            upgradeMessage = config?.upgradeMessage
        } else {
            upgradeMessage = nil
        }
    }
    
    func didType(_ chars: String) {
        switch chars {
            case "c":
                NSLog("cancel random")
                toggleRandom(canceled: true)
            
            case "e":
                NSLog("enable random")
                toggleRandom(canceled: false)
                enableRandomness()
            
            case "a":
                NSLog("add a video")
                addAVideo()
            
            case "r":
                NSLog("remove a video")
                removeAVideo()
            
            case "l":
                NSLog("lose a connection")
                loseAConnection()
            
            case "p":
                NSLog("pause a video")
                pauseAVideo()
            
            default:
                NSLog("unknown command")
        }
    }
}

extension Blockbuster: VideoPlayerViewDelegate {
    func videoPlayerViewIsReady(_ videoPlayerView: VideoPlayerView) {
        weCanStartNow()
    }
}
