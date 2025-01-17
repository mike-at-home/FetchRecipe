//
//  RecipeRow.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import SwiftUI

struct RecipeRow: View {
    @EnvironmentObject var imageProvider: ImageProvider

    var recipe: Model.Recipe

    var body: some View {
        Section {
            GeometryReader { geometry in
                HStack(alignment: .top) { }
                    .frame(maxWidth: .infinity)
                    .padding(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 250)
                    .background(
                        ParallaxView(content: VStack {
                            if let url = recipe.largePhoto {
                                LoadingView {
                                    try await imageProvider
                                        .getImage(for: url)
                                        .resizable(resizingMode: .stretch)
                                        .aspectRatio(1, contentMode: .fill)
                                }
                            } else {
                                Color(uiColor: .systemFill)
                            }
                        })
                        .zIndex(-1)
                        //                .mask(
                        //                    LinearGradient(
                        //                        gradient: Gradient(stops: [
                        //                            .init(color: .clear, location: 0),
                        //                            .init(color: .black, location: 0.05),
                        //                            .init(color: .black, location: 0.95),
                        //                            .init(color: .clear, location: 1),
                        //                        ]),
                        //                        startPoint: .top,
                        //                        endPoint: .bottom
                        //                    )
                        //                )
                    )
            }
            .aspectRatio(1, contentMode: .fill)
            .clipped()

        } header: {
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title3)
                Text(recipe.cuisine.demonym)
                    .font(.subheadline)
            }
        } footer: {
            HStack {
                Button(action: { }) {
                    Label(
                        "Add to Favorites",
                        systemImage: "bookmark.fill"
                    )
                }
            }
        }

//            .listRowSeparator(.hidden)
        .listRowInsets(.init())
    }
}

#Preview {
    RecipeList(recipes: Model.RecipeList.testList.recipes)
        .environmentObject(ImageProvider())
}
