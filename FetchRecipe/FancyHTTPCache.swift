//
//  FancyHTTPCache.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//


import Foundation

actor FancyHTTPCache {
    let session: URLSession = .shared
    var cache: [String: Task<Data, Error>] = [:]
    
    func getData(for url: URL) async throws -> Data {
        print(url)
        if let task = cache[url.absoluteString] {
            return try await task.value
        }
        
        let task = Task {
            try await session.data(from: url).0
        }
        
        cache[url.absoluteString] = task
        return try await task.value
    }
}
