//
//  ImageCache.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import UIKit
import AVKit

class MediaCache {
    static let shared = MediaCache()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let videoCache = NSCache<NSString, AVPlayerItem>()
    private var downloadTasks: [String: URLSessionDataTask] = [:]
    
    private init() {
        // Configure cache limits
        imageCache.countLimit = 100
        imageCache.totalCostLimit = 100 * 1024 * 1024 // 100 MB
        videoCache.countLimit = 20
    }
    
    // Image caching methods
    func getImage(from url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
    
    func storeImage(_ image: UIImage, for url: String) {
        let memoryFootprint = Int(image.size.width * image.size.height * 4) // Rough estimation of bytes
        imageCache.setObject(image, forKey: url as NSString, cost: memoryFootprint)
    }
    
    func prefetchImage(from urlString: String) {
        // Skip if already in cache
        if getImage(from: urlString) != nil { return }
        
        // Skip if already downloading
        if downloadTasks[urlString] != nil { return }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.downloadTasks[urlString] = nil }
            
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else { return }
            
            self?.storeImage(image, for: urlString)
        }
        
        downloadTasks[urlString] = task
        task.resume()
    }
    
    // Video caching methods
    func getVideoPlayerItem(from url: String) -> AVPlayerItem? {
        return videoCache.object(forKey: url as NSString)
    }
    
    func storeVideoPlayerItem(_ playerItem: AVPlayerItem, for url: String) {
        videoCache.setObject(playerItem, forKey: url as NSString)
    }
    
    func cancelAllDownloads() {
        downloadTasks.values.forEach { $0.cancel() }
        downloadTasks.removeAll()
    }
}
