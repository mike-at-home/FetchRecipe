//
//  ContentView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    @State var presentedURL: URL?
    @EnvironmentObject var recipeListProvider: RecipeListProvider

    var body: some View {
        NavigationView {
            LoadingView(resource: recipeListProvider.getRecipeList, content: {
                RecipeList(
                    recipes: $0,
                    onURLSelect: {
                        self.presentedURL = $0
                    }
                )
            })
            .fullScreenCover(
                isPresented: Binding(get: { presentedURL != nil }, set: {
                    if $0 { } else { presentedURL = nil }
                }),
                onDismiss: { },
                content: {
                    SafariView(url: presentedURL!)
                }
            )
        }
    }
}

#Preview {
    ContentView()
        .injectMockProviders()
}
