//
//  RecipeList.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct RecipeList: View {
    @State private var selected: UUID? = nil
    @State private var presented: URL? = nil
    let recipes: [Model.Recipe]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                if recipes.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("No recipes")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height - geometry.safeAreaInsets.top)
                } else {
                    ScrollViewReader { proxy in
                        LazyVStack {
                            ForEach(recipes) { recipe in
                                WrappedRecipeRow(
                                    recipe: recipe,
                                    selected: $selected,
                                    presented: $presented,
                                    scrollView: proxy
                                )
                            }
                        }
                    }
                }
            }
            .scrollBounceBehavior(.always)
        }
        .buttonStyle(RowButtonStyle())
        .animation(.spring(duration: 0.5, bounce: 0.3), value: selected)
        .fullScreenCover(
            isPresented: Binding(get: { presented != nil }, set: {
                if $0 { } else { presented = nil }
            }),
            content: {
                SafariView(url: presented!)
            }
        )
    }
}

#Preview {
    NavigationStack {
        RecipeList(recipes: Model.RecipeList.testList.recipes)
            .injectProviders()
    }
}

#Preview {
    NavigationStack {
        RecipeList(recipes: [])
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

private struct WrappedRecipeRow: View {
    var recipe: Model.Recipe
    var isSelected: Bool
    var onSelect: (UUID) -> Void
    var onDeselect: (UUID) -> Void
    var onTapURL: (URL) -> Void

    var body: some View {
        RecipeRow(
            name: recipe.name,
            cuisine: recipe.cuisine.text,
            youTubeURL: recipe.youTube,
            sourceURL: recipe.source,
            largePhotoURL: recipe.largePhoto,
            isSelected: isSelected,
            didTap: {
                if isSelected {
                    onDeselect(recipe.id)
                } else {
                    onSelect(recipe.id)
                }
            },
            didTapURL: onTapURL
        )
        .id(recipe.id)
    }
}

extension WrappedRecipeRow {
    init(
        recipe: Model.Recipe,
        selected: Binding<UUID?>,
        presented: Binding<URL?>,
        scrollView: ScrollViewProxy
    ) {
        self.init(
            recipe: recipe,
            isSelected: recipe.id == selected.wrappedValue,
            onSelect: { id in
                selected.wrappedValue = id
                withAnimation {
                    scrollView.scrollTo(id, anchor: .center)
                }
            },
            onDeselect: { id in
                selected.wrappedValue = nil
            },
            onTapURL: {
                presented.wrappedValue = $0
            }
        )
    }
}
