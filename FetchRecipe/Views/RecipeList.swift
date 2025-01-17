//
//  RecipeList.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct RecipeList: View {
    let recipes: [Model.Recipe]

    var body: some View {
        List(recipes) { recipe in
            RecipeRow(recipe: recipe)
        }
        .listStyle(.plain)
    }
}

#Preview {
    RecipeList(recipes: Model.RecipeList.testList.recipes)
}
