//
//  LoadingView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/14/25.
//

import SwiftUI

struct LoadingView<Content: View>: View {
    var source: () async throws -> Content
    @State var isLoading: Bool = false
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
                                let content = try await source()
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

#Preview {
    LoadingView(source: { Text("Loaded") })
}
