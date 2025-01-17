//
//  RecipeDetailsView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import SwiftUI

struct RecipeDetailsView: View {
    var recipe: Model.Recipe
    
    var body: some View {
        TabView {
            if let source = recipe.source {
                Tab {
                    WebView(url: source)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("Open in Safari", systemImage: "safari") {
                                    UIApplication.shared.open(source)
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        RecipeDetailsView(recipe: .init(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            name: "Apam Balik",
            cuisine: "Malaysian",
            source: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            youTube: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        ))
    }
}
