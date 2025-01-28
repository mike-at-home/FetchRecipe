//
//  MyURLCache.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/27/25.
//

import CryptoKit
import Foundation

/// Performs a data fetch for a URL
public protocol URLDataProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLDataProvider { }

/// Manages cached URL responses
public protocol URLCacheProtocol {
    func cachedResponse(for request: URLRequest) -> CachedURLResponse?
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest)
    func removeCachedResponse(for request: URLRequest)
    func removeAllCachedResponses()
}

extension URLCache: URLCacheProtocol { }

/// Deduplicates simultanous requests to same URL
public actor CoalescingURLDataProvider: URLDataProvider {
    private let dataProvider: URLDataProvider
    private var cache: [String: Task<(Data, URLResponse), Error>] = [:]

    public init(dataProvider: URLDataProvider) {
        self.dataProvider = dataProvider
    }

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        precondition(request.httpMethod?.lowercased() == "get", "only GET supported")

        let key = request.url!.absoluteString

        if let task = cache[key] {
            return try await task.value
        }

        let task = Task {
            try await dataProvider.data(for: request)
        }

        cache[key] = task
        defer { cache[key] = nil }
        return try await task.value
    }
}

/// Caches responses
public actor CachingURLDataProvider: URLDataProvider {
    private let remoteProvider: URLDataProvider
    private let cache: URLCacheProtocol

    public init(remoteProvider: URLDataProvider, cache: URLCacheProtocol) {
        self.remoteProvider = remoteProvider
        self.cache = cache
    }

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        precondition(request.httpMethod?.lowercased() == "get", "only GET supported")

        if let cachedResponse = cache.cachedResponse(for: request) {
            return (cachedResponse.data, cachedResponse.response)
        }

        let (data, response) = try await remoteProvider.data(for: request)
        let cached = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cached, for: request)
        return (data, response)
    }
}

public class MemoryURLCache: URLCacheProtocol {
    private var cache: [URL: CachedURLResponse] = [:]

    public init() { }
    
    public func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        precondition(request.httpMethod?.lowercased() == "get", "only GET supported")

        if let cachedResponse = cache[request.url!] {
            // TODO: check expiration conditions
            return cachedResponse
        }

        return nil
    }

    public func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        precondition(request.httpMethod?.lowercased() == "get", "only GET supported")
        // TODO: check expiration conditions
        cache[request.url!] = cachedResponse
    }

    public func removeCachedResponse(for request: URLRequest) {
        precondition(request.httpMethod?.lowercased() == "get", "only GET supported")
        // TODO: check expiration conditions
        cache[request.url!] = nil
    }

    public func removeAllCachedResponses() {
        cache.removeAll()
    }
}

/// caches responses to a folder on disk. removeAllCachedResponses() will remove all items in that folder.
public class DiskURLCache: URLCacheProtocol {
    private let cachePath: URL
    private let fileManager: FileManager

    public init(cachePath: URL = FileManager.default.temporaryDirectory.appending(path: "url_cache"), fileManager: FileManager = .default) {
        self.cachePath = cachePath
        self.fileManager = fileManager
        do {
            try fileManager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("failed to create cache path \(cachePath)")
        }
    }

    private func fileForRequest(_ request: URLRequest) -> URL {
        precondition(request.httpMethod?.lowercased() == "get", "only GET supported")
        guard let url = request.url else {
            preconditionFailure("expected URL for request")
        }
        let name = cacheFriendlyFilename(from: url)

        return cachePath.appendingPathComponent(name)
    }

    public func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let file = fileForRequest(request)

        if let data = try? Data(contentsOf: file),
           let cachedResponse = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CachedURLResponse.self, from: data)
        {
            return cachedResponse
        }

        return nil
    }

    public func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        let file = fileForRequest(request)
        let data = try! NSKeyedArchiver.archivedData(withRootObject: cachedResponse, requiringSecureCoding: true)
        do {
            try data.write(to: file)
        } catch {
            print("failed to cache file for \(request.url!)")
        }
    }

    public func removeCachedResponse(for request: URLRequest) {
        let file = fileForRequest(request)
        do {
            try FileManager.default.removeItem(at: file)
        } catch {
            print("failed to uncache file for \(request.url!)")
        }
    }

    public func removeAllCachedResponses() {
        do {
            try fileManager.removeItem(at: cachePath)
            try fileManager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("failed to recreate entire cache")
        }
    }
}

private func cacheFriendlyFilename(from url: URL) -> String {
    // Normalize the URL string
    let normalizedUrl = url.absoluteString.lowercased()

    // Hashing the URL using SHA256
    let hashed = SHA256.hash(data: Data(normalizedUrl.utf8))
    let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
    return hashString
}
