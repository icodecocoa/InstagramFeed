//
//  PostCellView.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import SwiftUI

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User info header
            HStack {
                Image(post.profileImage.localResource ?? "placeholder_profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(post.username)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "ellipsis")
            }
            .padding(.horizontal)
            
            // Media section
            if post.mediaItems.count == 1 {
                // Single media item
                SingleMediaView(mediaItem: post.mediaItems[0])
                    .frame(height: 400)
            } else {
                // Multiple media items
                TabView {
                    ForEach(post.mediaItems) { item in
                        SingleMediaView(mediaItem: item)
                    }
                }
                .frame(height: 400)
                .tabViewStyle(PageTabViewStyle())
            }
            
            // Action buttons
            HStack {
                Image(systemName: "heart")
                    .font(.title2)
                Image(systemName: "bubble.right")
                    .font(.title2)
                Image(systemName: "paperplane")
                    .font(.title2)
                Spacer()
                Image(systemName: "bookmark")
                    .font(.title2)
            }
            .padding(.horizontal)
            
            // Likes count
            Text("\(post.likes) likes")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // Caption
            HStack {
                Text(post.username).fontWeight(.semibold) +
                Text(" ") +
                Text(post.caption)
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            // Timestamp
            Text(timeAgo(from: post.timestamp))
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 2)
        }
        .background(Color(.systemBackground))
    }
    
    func timeAgo(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let days = seconds / 86400
            return "\(days)d ago"
        }
    }
}
