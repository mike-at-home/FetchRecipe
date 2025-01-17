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
        GeometryReader { geometry in
            Group {
                HStack(alignment: .top) {
                    VStack {
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.title3)
                            Text(recipe.cuisine.demonym)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Material.ultraThinMaterial)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
                            topLeading: 0,
                            bottomLeading: 0,
                            bottomTrailing: 15,
                            topTrailing: 15
                        )))

                        Spacer()

                        HStack {
                            Button(action: { }) {
                                Label(
                                    "Add to Favorites",
                                    systemImage: "bookmark.fill"
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .background(Material.ultraThinMaterial)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.init(top: 15, leading: 0, bottom: 0, trailing: 0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 250)
                .background(HStack {
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
                })
                .clipped()
            }

        }.frame(height: 200)
            .listRowSpacing(40)
//            .listRowSeparator(.hidden)
            .listRowInsets(.init())
    }
}

#Preview {
    RecipeList(recipes: Model.RecipeList.testList.recipes)
        .environmentObject(ImageProvider())
}
