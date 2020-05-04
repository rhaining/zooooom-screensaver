//
//  VideoPlayerView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import AVFoundation
import AppKit
import AVKit

protocol VideoPlayerViewDelegate {
    func videoPlayerViewIsReady(_ videoPlayerView: VideoPlayerView)
}

final class VideoPlayerView: NSView {
    var delegate: VideoPlayerViewDelegate?
    let url: URL

    private let playerView: AVPlayerView = {
        let pv = AVPlayerView()
        pv.controlsStyle = .none
        return pv
    }()
    
    private let stateOverlay = VideoPlayerStateOverlay()
    
    init(url: URL) {
        self.url = url
        
        super.init(frame: .zero)
        
        let player = AVPlayer(url: url)
        player.isMuted = true
        playerView.player = player
        
        addSubview(playerView)
        addVideoEndedNotification()
        
        addSubview(stateOverlay)
        
        setupStalledObservation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        needsLayout = true
    }
    override func layout() {
        super.layout()
        playerView.frame = bounds
        updateStateOverlayLayout()
    }
    
    private func updateStateOverlayLayout() {
        if playerView.videoBounds.equalTo(.zero) {
            stateOverlay.frame = bounds
        } else {
            stateOverlay.frame = playerView.videoBounds
        }
    }
    
    func play(to percent: Double? = nil) {
        guard let player = playerView.player,
            let currentItem = player.currentItem,
            !stateOverlay.isLost else { return }
        
        if let percent = percent {
            let value = percent * currentItem.asset.duration.seconds
            let time = CMTime(seconds: value, preferredTimescale: 1)
            player.seek(to: time)
        }
        
        player.play()
        
        playerView.alphaValue = 1
        
        stateOverlay.state = .none
    }
    
    func pause(message: String?, warning: Bool = false) {
        guard !stateOverlay.isLost else { return }
        
        playerView.player?.pause()
        
        playerView.alphaValue = 0.6
        
        stateOverlay.state = warning ? .lost(message) : .paused(message)
    }
    
    
    private func addVideoEndedNotification() {
        removeVideoEndedNotification()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    private func removeVideoEndedNotification() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    @objc private func playerDidFinishPlaying() {
        //loop
        play(to: 0)
    }
    
    private var stalledObservation: NSKeyValueObservation?
    private var dateOfStall: Date?
    private func setupStalledObservation() {
        stalledObservation = playerView.player?.observe(\.reasonForWaitingToPlay,
                              options: .new,
                              changeHandler: { [weak self] (object, change) in
                                self?.didUpdateReasonForWaitingToPlay()
        })
    }
    private func didUpdateReasonForWaitingToPlay() {
        guard !stateOverlay.isLost else { return }

        let isStalled = (playerView.player?.reasonForWaitingToPlay != nil)
        if isStalled {
            dateOfStall = Date()
        } else {
            dateOfStall = nil
            delegate?.videoPlayerViewIsReady(self)
        }
        stateOverlay.state = isStalled ? .loading : .none
        
        updateStateOverlayLayout()
    }
    
    var cannotPlay: Bool { return playerView.player?.reasonForWaitingToPlay != nil }
    var timeSinceStall: TimeInterval? { return dateOfStall?.timeIntervalSinceNow }
}
