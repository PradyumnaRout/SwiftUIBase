//
//  GlobalUtility.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import Foundation
import SwiftMessages
import UIKit
import SwiftUI
import SwiftUI

class GlobalUtility {

    static let shared = GlobalUtility()

    @MainActor func showAlert(title: String = "BaseSwiftUI", body: String, theme: Theme = .error) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.backgroundView.backgroundColor = theme == .success ? .blue : .red
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.bodyLabel?.font = .systemFont(ofSize: 18, weight: .regular)//.sulphurFont(weight: .Bold, size: 18)
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)//.sulphurFont(weight: .Bold, size: 22)
        view.iconImageView?.isHidden = true

        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.duration = .seconds(seconds: 5)

        SwiftMessages.show(config: config, view: view)
    }
    
    func deepCopyInstance<T: Codable>(_ object: T) -> T {
        do {
            // Serialize the object to JSON
            let jsonData = try JSONEncoder().encode(object)
            // Deserialize back to create a copy
            let copiedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return copiedObject
        } catch {
            fatalError("Failed to copy object: \(error)")
        }
    }
    
    func showOverlay(view: some View, viewTag: Int = 999) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let overlay = UIHostingController(rootView: view)
        overlay.view.backgroundColor = .clear
        overlay.view.frame = window.bounds
        overlay.view.tag = viewTag  // Optional: so you can find/remove it later

        window.addSubview(overlay.view)
    }
    
    func removeOverlay(viewTag: Int = 999) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        if let overlayView = window.viewWithTag(viewTag) {
            overlayView.removeFromSuperview()
        }
    }
    
    func forceResignKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


