//
//  ImageProvider.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import Foundation
import SwiftUI

actor ImageProvider: ObservableObject {
    let cache: FancyHTTPCache = .init()
    
    func getImage(for url: URL) async throws -> Image {
        let data = try await cache.getData(for: url)
        return Image(uiImage: .init(data: data)!)
    }
}
