//
//  LPLinkViewView.swift
//  LinkPreviewToy (macOS)
//
//  Created by Jaanus Kase on 07.01.2022.
//

import Foundation
import SwiftUI
import LinkPresentation

class CustomLinkView: LPLinkView {
    override var intrinsicContentSize: CGSize { CGSize(width: 0, height: super.intrinsicContentSize.height) }
}



#if os(macOS)
struct LPLinkViewView: NSViewRepresentable {
    typealias NSViewType = CustomLinkView

    let metadata: LPLinkMetadata
    
    func makeNSView(context: Context) -> CustomLinkView {
        guard let metadata = metadata else { return CustomLinkView() }
        let linkView = CustomLinkView(metadata: metadata)
        return linkView
    }

    func updateNSView(_ uiView: CustomLinkView, context: Context) { }
}
#else
struct LPLinkViewView: UIViewRepresentable {

    typealias UIViewType = CustomLinkView

    var metadata: LPLinkMetadata?

    func makeUIView(context: Context) -> CustomLinkView {
        guard let metadata = metadata else { return CustomLinkView() }
        let linkView = CustomLinkView(metadata: metadata)
        return linkView
    }

    func updateUIView(_ uiView: CustomLinkView, context: Context) { }
}

struct LPLinkPlaceholderView: UIViewRepresentable {

    typealias UIViewType = CustomLinkView

    var url: URL

    func makeUIView(context: Context) -> CustomLinkView {
        let linkView = CustomLinkView(url: url)
        return linkView
    }

    func updateUIView(_ uiView: CustomLinkView, context: Context) { }
}
#endif

struct LinkView: View {
    var url: URL?
    @State private var metadata: LPLinkMetadata? = nil
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.0)
                .fill(.background.secondary)

            if let metadata {
                LPLinkViewView(metadata: metadata)
                    .frame(width: 300, height: 300, alignment: .bottom)
                    .transition(.opacity.animation(.snappy))
            }
        }
        .frame(width: 300, height: 300, alignment: .bottom)

        .task(id: url) {
            guard let url else { return }
            self.metadata = try? await LPMetadataProvider().startFetchingMetadata(for: URLRequest(url: url))
        }
    }
}

#Preview {
    LinkView(url: URL(string: "https://developer.apple.com/documentation/xcode/configuring-app-groups")!)
}

