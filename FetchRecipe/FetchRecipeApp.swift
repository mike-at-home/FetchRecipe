//
//  FetchRecipeApp.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

@main
struct FetchRecipeApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .injectProviders()
        }
    }
}

extension View {
    func injectProviders(
        dataProvider: URLDataProvider = URLSession.shared,
        urlCache: URLCacheProtocol = MemoryURLCache(),
        endpoint: RecipeListEndpoint = .full
    ) -> some View {
        // wrap URLSession to only allow 1 request to a particular url at a time
        let coalescingProvider = CoalescingURLDataProvider(dataProvider: dataProvider)

        // add a caching layer
        let urlDataProvider = CachingURLDataProvider(remoteProvider: coalescingProvider, cache: urlCache)

        let imageProvider = RemoteImageProvider(dataProvider: urlDataProvider)
        let recipeListProvider = RemoteRecipeListProvider(dataProvider: urlDataProvider, url: endpoint.url)

        return self
            .environmentObject(ImageProvider(wrapped: imageProvider))
            .environmentObject(RecipeListProvider(wrapped: recipeListProvider))
    }

    func injectMockProviders() -> some View {
        return self
            .injectProviders()
            .environmentObject(RecipeListProvider(wrapped: MockRecipeListProvider()))
    }
}
