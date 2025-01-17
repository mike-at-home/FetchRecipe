//
//  ContentView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RecipeList(recipes: Model.RecipeList.testList.recipes)
            .environmentObject(ImageProvider())
    }
}

#Preview {
    ContentView()
}
