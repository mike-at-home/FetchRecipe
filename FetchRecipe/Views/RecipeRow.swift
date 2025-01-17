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
        HStack(alignment: .top) {
            VStack {
                if let url = recipe.smallPhoto {
                    LoadingView {
                        try await imageProvider.getImage(for: url)
                    }
                } else {
                    Color(uiColor: .systemFill)
                }
            }
            .aspectRatio(1, contentMode: .fit)
                .frame(height: 100)
            

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .background(Color.yellow)
                Text(recipe.cuisine.demonym)
                    .font(.subheadline)
                    .background(Color.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green)
        }
        .padding(10)
    }

//    var body: some View {
//        HStack(alignment: .top, spacing: 8) {
//            GeometryReader { proxy in
//                Rectangle()
//                    .fill(Color(UIColor.systemFill))
//                    .frame(width: proxy.size.height, height: proxy.size.height)
//            }
//
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(recipe.name)
//                        .font(.headline)
//                        .lineLimit(1)
//                        .background(.yellow)
//                    Spacer()
//                }.frame(maxWidth: .infinity)
//
//                HStack {
//                    Text(recipe.cuisine.demonym)
//                        .lineLimit(1)
//                        .font(.subheadline)
//                        .background(.green)
//                    Spacer()
//                }.frame(maxWidth: .infinity)
//            }
//            .multilineTextAlignment(.leading)
//            .background(.blue)
//        }
//
//        .padding()
//    }
}

#Preview {
    VStack {
        Spacer().layoutPriority(1)
        RecipeRow(recipe: Model.RecipeList.testList.recipes[0])
        RecipeRow(recipe: Model.RecipeList.testList.recipes[1])
        Spacer().layoutPriority(1)
    }
    .environmentObject(ImageProvider())
}
