//
//  RecipeListProvider.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import Foundation
import SwiftUI

public class RecipeListProvider: RecipeListProviderProtocol, ObservableObject {
    private let wrapped: RecipeListProviderProtocol

    init(wrapped: RecipeListProviderProtocol) {
        self.wrapped = wrapped
    }

    public func getRecipeList() async throws -> [Model.Recipe] {
        try await wrapped.getRecipeList()
    }
}

public protocol RecipeListProviderProtocol {
    func getRecipeList() async throws -> [Model.Recipe]
}

public actor MockRecipeListProvider: RecipeListProviderProtocol {
    public func getRecipeList() async throws -> [Model.Recipe] {
        Model.RecipeList.testList.recipes
    }
}

public actor RemoteRecipeListProvider: RecipeListProviderProtocol {
    private let url: URL
    private let dataProvider: URLDataProvider

    public init(
        dataProvider: URLDataProvider,
        url: URL
    ) {
        self.dataProvider = dataProvider
        self.url = url
    }

    public func getRecipeList() async throws -> [Model.Recipe] {
        let data = try await dataProvider.data(for: .init(url: url))
        return try JSONDecoder().decode(Model.RecipeList.self, from: data.0).recipes
    }
}
