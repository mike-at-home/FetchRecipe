//
//  RecipeList.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct RecipeList: View {
    @State var selected: UUID? = nil
    let recipes: [Model.Recipe]
    var onURLSelect: (URL) -> Void

    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(recipes) { recipe in
                        RecipeRow(recipe: recipe, isSelected: selected == recipe.id, didTap: {
                            if selected == recipe.id {
                                selected = nil
                            } else {
                                selected = recipe.id
                                withAnimation {
                                    proxy.scrollTo(selected, anchor: .center)
                                }
                            }
                        },
                        didTapURL: onURLSelect)
                            .id(recipe.id)
                    }
                }
            }
        }
        .buttonStyle(RowButtonStyle())
        .animation(.spring(duration: 0.5, bounce: 0.3), value: selected)
    }
}

#Preview {
    NavigationStack {
        RecipeList(recipes: Model.RecipeList.testList.recipes, onURLSelect: { _ in })
            .injectProviders()
    }
}

struct RowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1, anchor: .center)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(RowButtonStyle())
}
