//
//  Untitled.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import UIKit

enum MediaType {
    case image
    case video
}

struct MediaItem: Identifiable {
    let id = UUID()
    let type: MediaType
    let url: String
    
    // Local resources have "local:" prefix, remote have "https:"
    var isLocal: Bool {
        return url.hasPrefix("local:")
    }
    
    var localResource: String? {
        guard isLocal else { return nil }
        return String(url.dropFirst(6)) // Remove "local:" prefix
    }
}
