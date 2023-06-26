//
//  ShareViewController.swift
//  iOSShareExtension
//
//  Created by Stef Kors on 16/05/2023.
//

import UIKit
import SwiftData
import SwiftUI
import UniformTypeIdentifiers


@objc(ShareExtensionViewController)
class ShareViewController: UIViewController {

    // override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentView = ShareContentView()
            .modelContainer(for: EntryItem.self)
            .environment(\.extensionContext, extensionContext)

        view = UIHostingView(rootView: contentView)
        view.isOpaque = true
        view.backgroundColor = .systemBackground
    }
}
