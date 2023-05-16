//
//  SafariWebView.swift
//  Enticement
//
//  Created by Stef Kors on 16/05/2023.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
}

struct SafariWebView_Previews: PreviewProvider {
    static var previews: some View {
        SafariWebView(url: URL(string: "https://www.example.com")!)
    }
}
