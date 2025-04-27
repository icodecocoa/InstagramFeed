//
//  CachedImageView.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import SwiftUI

struct CachedImageView: View {
    let imageUrl: String
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        // Handle local image
        if imageUrl.hasPrefix("local:") {
            let imageName = String(imageUrl.dropFirst(6))
            if let localImage = UIImage(named: imageName) {
                self.image = localImage
            } else {
                self.image = UIImage(systemName: "photo")
            }
            return
        }
        
        // Check cache first
        if let cachedImage = MediaCache.shared.getImage(from: imageUrl) {
            self.image = cachedImage
            return
        }
        
        // Download if not in cache
        guard let url = URL(string: imageUrl) else {
            self.image = UIImage(systemName: "exclamationmark.triangle")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.image = UIImage(systemName: "exclamationmark.triangle")
                }
                return
            }
            
            // Cache the downloaded image
            MediaCache.shared.storeImage(downloadedImage, for: imageUrl)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
