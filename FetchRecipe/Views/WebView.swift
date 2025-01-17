//
//  WebView.swift
//  FetchRecipe
//
//  Created by Michael Kasianowicz on 1/15/25.
//

import SwiftUI
import WebKit

struct WebView: View, UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(.init(url: url))
    }
    
    typealias UIViewType = WKWebView
    
    var url: URL
}

#Preview {
    WebView(url: .init(string: "http://google.com")!)
}
