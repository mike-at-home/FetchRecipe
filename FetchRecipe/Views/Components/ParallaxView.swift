//
//  ParallaxView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/16/25.
//

import SwiftUI

/// small parallax effect on content depending place on screen
struct ParallaxView<Content: View>: View {
    public var content: Content

    var body: some View {
        GeometryReader { geometry in
            content
                .offset(y: calculateParallaxOffset(geometry: geometry))
        }
    }

    private func calculateParallaxOffset(geometry: GeometryProxy) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        let frame = geometry.frame(in: .global)
        let contentHeight = frame.width
        let contentRange = contentHeight - frame.height
        
        // when Y is 0, content offset is content height - cell height
        // when Y is bounds - cell height, content offset is 0
        
        let rangeY = screenBounds.maxY - screenBounds.minY - frame.height
        
        let progress = min(max((frame.minY - screenBounds.minY) / rangeY, 0), 1)
        
        let offset = (1 - progress) * contentRange
        return -(offset / 5)
    }
}

#Preview {
    MainView().injectMockProviders()
}
