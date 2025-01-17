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
        ScrollView {
            ForEach(recipes) { recipe in
                RecipeRow(recipe: recipe)
            }
        }
    }
}

#Preview {
    RecipeList(recipes: Model.RecipeList.testList.recipes).environmentObject(ImageProvider())
}
