//
//  SafariView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        configuration.barCollapsingEnabled = false
        return .init(url: url, configuration: configuration)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }

    typealias UIViewControllerType = SFSafariViewController
}

#Preview {
    NavigationView {
        SafariView(url: .init(string: "http://google.com")!)
    }
}
