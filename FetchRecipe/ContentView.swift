//
//  ContentView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RecipeList(recipes: .init(Model.RecipeList.testList.recipes.prefix(upTo: 10)))
            .environmentObject(ImageProvider())
    }
}

#Preview {
    ContentView()
}
