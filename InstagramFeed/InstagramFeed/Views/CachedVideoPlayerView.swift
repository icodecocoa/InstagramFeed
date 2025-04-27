//
//  CachedVideoPlayerView.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import SwiftUI
import AVKit

struct CachedVideoPlayerView: View {
    let videoUrl: String
    @State private var player: AVPlayer?
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        isVisible = true
                        player.play()
                    }
                    .onDisappear {
                        isVisible = false
                        player.pause()
                    }
            } else {
                ProgressView()
                    .onAppear {
                        setupPlayer()
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            player?.pause()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if isVisible {
                player?.play()
            }
        }
    }
    
    private func setupPlayer() {
        // Handle local video
        if videoUrl.hasPrefix("local:") {
            let videoName = String(videoUrl.dropFirst(6))
            if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
                let url = URL(fileURLWithPath: path)
                self.player = AVPlayer(url: url)
            }
            return
        }
        
        // Check cache first
        if let cachedPlayerItem = MediaCache.shared.getVideoPlayerItem(from: videoUrl) {
            self.player = AVPlayer(playerItem: cachedPlayerItem)
            return
        }
        
        // Download if not in cache
        guard let url = URL(string: videoUrl) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        
        // Store in cache after fully loaded
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
            MediaCache.shared.storeVideoPlayerItem(playerItem, for: videoUrl)
            // Loop the video
            self.player?.seek(to: .zero)
            if self.isVisible {
                self.player?.play()
            }
        }
    }
}
