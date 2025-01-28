//
//  RecipeListEndpoint.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/28/25.
//
import Foundation

public struct RecipeListEndpoint {
    public let url: URL

    private init(_ string: String) {
        self.url = .init(string: string)!
    }

    public static let full: Self = .init("https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    public static let empty: Self = .init("https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    public static let malformed: Self = .init("https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
}
