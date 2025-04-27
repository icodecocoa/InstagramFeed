//
//  Post.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import UIKit

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let profileImage: String
    let caption: String
    let likes: Int
    let mediaItems: [MediaItem]
    let timestamp: Date
}
