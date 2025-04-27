//
//  LocalResource.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

extension String {
    
    // Local resources have "local:" prefix, remote have "https:"
    var isLocal: Bool {
        return self.hasPrefix("local:")
    }
    
    var localResource: String? {
        guard isLocal else { return nil }
        return String(self.dropFirst(6)) // Remove "local:" prefix
    }
}
