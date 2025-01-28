//
//  LoadingRecipeListView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/28/25.
//

import SwiftUI

struct LoadingRecipeListView: View {
    @EnvironmentObject var recipeListProvider: RecipeListProvider

    var body: some View {
        LoadingView(
            resource: recipeListProvider.getRecipeList,
            content: RecipeList.init
        )
    }
}

#Preview {
    LoadingRecipeListView()
        .injectMockProviders()
}
