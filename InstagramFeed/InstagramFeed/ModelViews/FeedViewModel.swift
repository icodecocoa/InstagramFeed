//
//  FeedViewModel.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import UIKit
import Combine

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let mediaCache = MediaCache.shared
    
    init() {
        loadPosts()
    }
    
    func loadPosts() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            self.posts = self.getMockPosts()
            
            // Pre-cache images
            for post in self.posts {
                for mediaItem in post.mediaItems where mediaItem.type == .image {
                    if !mediaItem.isLocal {
                        self.mediaCache.prefetchImage(from: mediaItem.url)
                    }
                }
            }
        }
    }
    
    func refreshFeed() {
        loadPosts()
    }
    
    // Sample mock data
    private func getMockPosts() -> [Post] {
        return [
            Post(
                username: "nature_lover",
                profileImage: "local:person1",
                caption: "Beautiful sunset at the beach 🌅",
                likes: 234,
                mediaItems: [
                    MediaItem(type: .image, url: "local:sunset"),
                    MediaItem(type: .video, url: "local:beach_waves")
                ],
                timestamp: Date().addingTimeInterval(-3600)
            ),
            Post(
                username: "food_explorer",
                profileImage: "local:person2",
                caption: "Making homemade pasta today! 🍝",
                likes: 156,
                mediaItems: [
                    MediaItem(type: .video, url: "local:cooking")
                ],
                timestamp: Date().addingTimeInterval(-7200)
            ),
            Post(
                username: "travel_addict",
                profileImage: "local:person3",
                caption: "Exploring the mountains ⛰️",
                likes: 487,
                mediaItems: [
                    MediaItem(type: .image, url: "local:mountains")
                ],
                timestamp: Date().addingTimeInterval(-86400)
            ),
            Post(
                username: "urban_photographer",
                profileImage: "local:person4",
                caption: "City lights and urban life 🌃",
                likes: 321,
                mediaItems: [
                    MediaItem(type: .image, url: "local:cityscape"),
                    MediaItem(type: .video, url: "local:city_timelapse")
                ],
                timestamp: Date().addingTimeInterval(-172800)
            )
        ]
    }
}

