//
//  RecipeRow.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import SwiftUI

struct RecipeRow: View {
    var name: String
    var cuisine: String
    var youTubeURL: URL?
    var sourceURL: URL?
    var largePhotoURL: URL?
    
    var isSelected: Bool
    var didTap: () -> Void
    var didTapURL: (URL) -> Void

    var body: some View {
        Button(action: self.didTap) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        RecipeHeaderView(
                            name: name,
                            cuisine: cuisine
                        )

                        Spacer()

                        CellButtonGroup(
                            youTubeURL: youTubeURL,
                            sourceURL: sourceURL,
                            didTapURL: didTapURL
                        )
                        .opacity(isSelected ? 1 : 0)
                    }
                }
                .aspectRatio(isSelected ? 0.75 : 1.5, contentMode: .fill)
                .background(CellBackgroundView(url: largePhotoURL))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .clipped()
                .shadow(radius: 5)
            }
            .padding()
        }
    }
}

#Preview {
    MainView()
        .injectMockProviders()
}

/// fancy button inside cell
private struct CellLinkButtonStyle: ButtonStyle {
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
private struct CellLinkButtonLabelStyle: LabelStyle {
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

private struct CellBackgroundView: View {
    @EnvironmentObject private var imageProvider: ImageProvider
    public let url: URL?

    var body: some View {
        ParallaxView(content: VStack {
            if let url {
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
    }
}

struct RecipeHeaderView: View {
    var name: String
    var cuisine: String

    var body: some View {
        VStack(alignment: .center) {
            Text(name)
                .font(.title3)
                .foregroundStyle(.primary)

            Text(cuisine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

struct CellButtonGroup: View {
    var youTubeURL: URL?
    var sourceURL: URL?
    var didTapURL: (URL) -> Void

    var body: some View {
        Grid(horizontalSpacing: 20) {
            GridRow {
                if let youTubeURL {
                    Button(action: { self.didTapURL(youTubeURL) }) {
                        Label("YouTube", systemImage: "video")
                    }
                }

                if let sourceURL {
                    Button(action: { self.didTapURL(sourceURL) }) {
                        Label("Source", systemImage: "safari")
                    }
                }
            }
        }
        .buttonStyle(CellLinkButtonStyle())
        .padding()
    }
}
