//
//  MainView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Full List", destination: {
                    LoadingRecipeListView()
                        .injectProviders(endpoint: .full)
                })
                NavigationLink("Empty List", destination: {
                    LoadingRecipeListView()
                        .injectProviders(endpoint: .empty)
                })
                NavigationLink("Malformed List", destination: {
                    LoadingRecipeListView()
                        .injectProviders(endpoint: .malformed)
                })
            }
        }
    }
}

#Preview {
    MainView()
        .injectMockProviders()
}
