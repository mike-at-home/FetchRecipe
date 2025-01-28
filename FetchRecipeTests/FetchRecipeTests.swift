//
//  FetchRecipeTests.swift
//  FetchRecipeTests
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import FetchRecipe
import Foundation
import Testing

struct FetchRecipeTests {
    @Test
    func testDecode() async throws {
        let data = try await URLSession.shared.data(for: RecipeListEndpoint.full.url)
        let list = try JSONDecoder().decode(Model.RecipeList.self, from: data.0)
        #expect(!list.recipes.isEmpty)
    }

    @Test
    func testDecodeMalformed() async throws {
        let data = try await URLSession.shared.data(for: RecipeListEndpoint.malformed.url)
        var threw = false
        do {
            let _ = try JSONDecoder().decode(Model.RecipeList.self, from: data.0)
        } catch {
            threw = true
        }
        #expect(threw)
    }

    @Test
    func testDecodeEmpty() async throws {
        let data = try await URLSession.shared.data(for: RecipeListEndpoint.empty.url)
        let list = try JSONDecoder().decode(Model.RecipeList.self, from: data.0)
        #expect(list.recipes.isEmpty)
    }

    @Test
    func testMemCache() async throws {
        let cache = MemoryURLCache()
        let provider = CachingURLDataProvider(remoteProvider: URLSession.shared, cache: cache)

        let req = URLRequest(url: testURL)
        _ = try await provider.data(for: req)

        #expect(cache.cachedResponse(for: req) != nil)

        cache.removeCachedResponse(for: req)

        #expect(cache.cachedResponse(for: req) == nil)
    }

    @Test
    func testDiskCache() async throws {
        let cache = DiskURLCache()
        let provider = CachingURLDataProvider(remoteProvider: URLSession.shared, cache: cache)

        let req = URLRequest(url: testURL)
        _ = try await provider.data(for: req)

        #expect(cache.cachedResponse(for: req) != nil)

        cache.removeCachedResponse(for: req)

        #expect(cache.cachedResponse(for: req) == nil)
    }
}
