//
//  RemoteImageProvider.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import Foundation
import SwiftUI

public class ImageProvider: ObservableObject, ImageProviderProtocol {
    private let wrapped: ImageProviderProtocol

    public init(wrapped: ImageProviderProtocol) {
        self.wrapped = wrapped
    }

    public func getImage(for url: URL) async throws -> Image {
        try await wrapped.getImage(for: url)
    }
}

public protocol ImageProviderProtocol {
    func getImage(for url: URL) async throws -> Image
}

public class RemoteImageProvider: ImageProviderProtocol {
    private let dataProvider: URLDataProvider

    public init(dataProvider: URLDataProvider) {
        self.dataProvider = dataProvider
    }

    public func getImage(for url: URL) async throws -> Image {
        let data = try await dataProvider.data(for: .init(url: url)).0
        return Image(uiImage: .init(data: data)!)
    }
}
