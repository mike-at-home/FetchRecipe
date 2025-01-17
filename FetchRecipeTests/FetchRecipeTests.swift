//
//  FetchRecipeTests.swift
//  FetchRecipeTests
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import Testing
import Foundation



struct FetchRecipeTests {
    static let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    @Test func example() async throws {
        let data = try await URLSession().data(for: .init(url: Self.testURL))
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        print(data)
    }
    
    

}
