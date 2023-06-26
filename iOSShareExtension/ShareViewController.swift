//
//  ShareViewController.swift
//  iOSShareExtension
//
//  Created by Stef Kors on 16/05/2023.
//

import UIKit
import Social
import SwiftUI

@objc(ShareExtensionViewController)
class ShareViewController: UIHostingController<ShareView> {
    required init?(coder aDecoder: NSCoder) {
        let view = ShareView(label: "testing")
        super.init(coder: aDecoder, rootView: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // UserPreferences.hasOpenedShareSheet = true
        // viewModel.delegate = self
        // self.handleSharedURL()
    }
}

// extension ShareViewController: ShareViewModelDelegate {
//     func didFinish(cancelled: Bool) {
//         if cancelled, let domain = Bundle.main.bundleIdentifier {
//             extensionContext?.cancelRequest(withError: NSError(domain: domain, code: 0))
//         } else {
//             extensionContext?.completeRequest(returningItems: nil)
//         }
//     }
// }

struct ShareView: View {
    @State public var label: String

    var body: some View {
        Text(label)
    }
}
