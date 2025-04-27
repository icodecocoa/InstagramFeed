//
//  VisibilityCa.swift
//  InstagramFeed
//
//  Created by Drashti Lakhani on 4/27/25.
//

import SwiftUI
import Foundation

// MARK: - Visibility Tracker for Videos
struct VisibilityTracker<Content: View>: View {
    @Binding var isVisible: Bool
    let content: Content
    
    init(isVisible: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isVisible = isVisible
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: VisibilityPreferenceKey.self, value: geometry.frame(in: .global))
                }
            )
            .onPreferenceChange(VisibilityPreferenceKey.self) { bounds in
                let screenBounds = UIScreen.main.bounds
                let isVisible = bounds.intersects(screenBounds)
                self.isVisible = isVisible
            }
    }
    
    struct VisibilityPreferenceKey: PreferenceKey {
        static var defaultValue: CGRect {
            get {
                return .zero
            }
        }
        
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
}
