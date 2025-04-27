//
//  SingleMediaView.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import SwiftUI

struct SingleMediaView: View {
    let mediaItem: MediaItem
    
    var body: some View {
        if mediaItem.type == .image {
            CachedImageView(imageUrl: mediaItem.url)
                .scaledToFill()
                .clipped()
        } else {
            CachedVideoPlayerView(videoUrl: mediaItem.url)
        }
    }
}
