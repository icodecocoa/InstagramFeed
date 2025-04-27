//
//  FeedView.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error loading feed")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Button("Retry") {
                            viewModel.loadPosts()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.posts) { post in
                                PostView(post: post)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Instagram Feed")
            .navigationBarItems(trailing: Button(action: {
                viewModel.refreshFeed()
            }) {
                Image(systemName: "arrow.clockwise")
            })
        }
    }
}
