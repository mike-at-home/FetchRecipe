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
    var isSelected: Bool
    var didTap: () -> Void
    var didTapURL: (URL) -> Void

    var body: some View {
        Button(action: self.didTap) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        VStack(alignment: .center) {
                            Text(recipe.name)
                                .font(.title3)
                                .foregroundStyle(.primary)

                            Text(recipe.cuisine.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)

                        Spacer()

                        Grid(horizontalSpacing: 20) {
                            GridRow {
                                if let ytURL = recipe.youTube {
                                    Button(action: { self.didTapURL(ytURL) }) {
                                        Label("YouTube", systemImage: "video")
                                    }
                                }

                                if let sourceURL = recipe.source {
                                    Button(action: { self.didTapURL(sourceURL) }) {
                                        Label("Source", systemImage: "safari")
                                    }
                                }
                            }
                        }
                        .buttonStyle(CellLinkButtonStyle())
                        .opacity(isSelected ? 1 : 0)
                        .padding()
                    }
                }
                .aspectRatio(isSelected ? 0.75 : 1.5, contentMode: .fill)
                .background(
                    ParallaxView(content: VStack {
                        if let url = recipe.largePhoto {
                            LoadingView {
                                try await imageProvider
                                    .getImage(for: url)
                                    .resizable(resizingMode: .stretch)
                                    .aspectRatio(1, contentMode: .fill)
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Color(uiColor: .systemFill)
                        }
                    })
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .clipped()
                .shadow(radius: 5)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
        .injectMockProviders()
}

/// fancy button inside cell
struct CellLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(CellLinkButtonLabelStyle())
            .padding(10)
            .background(.ultraThinMaterial, in: .buttonBorder)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

#Preview {
    VStack {
        Spacer()
        Button(action: { print("Pressed") }) {
            Label("Press Me", systemImage: "star")
        }
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(.red)
    .buttonStyle(CellLinkButtonStyle())
}

/// label style inside fancy button
struct CellLinkButtonLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .imageScale(.medium)
                .padding(12)
                .frame(height: 40)
                .background(.thinMaterial, in: Circle())
                .foregroundStyle(.primary)

            configuration.title
                .font(.caption)
                .foregroundStyle(.regularMaterial)
        }
        .frame(width: 80)
    }
}

#Preview {
    VStack {
        Label("Title 1", systemImage: "star")
        Label("Title 2", systemImage: "square")
        Label("Title 3", systemImage: "circle")
    }
    .labelStyle(CellLinkButtonLabelStyle())
}
