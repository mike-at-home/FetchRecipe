//
//  LoadingView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct LoadingView<Content: View>: View {
    var content: () async throws -> Content
    @State var isLoading = false
    @State var result: Result<Content, Error>?

    var body: some View {
        if let result {
            switch result {
            case let .success(content):
                content
                    .transition(.opacity)
            default:
                Text("Error")
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .onAppear {
                    if self.result == nil, !isLoading {
                        isLoading = true
                        Task {
                            do {
                                let content = try await content()
                                self.result = .success(content)
                            } catch {
                                self.result = .failure(error)
                            }
                            self.isLoading = false
                        }
                    }
                }
        }
    }
}

extension LoadingView {
    public init<R>(resource: @escaping () async throws -> R, content: @escaping (R) -> Content) {
        self.init(content: {
            let result = try await resource()
            return content(result)
        })
    }
}

#Preview {
    LoadingView(content: { Text("Loaded") })
}
