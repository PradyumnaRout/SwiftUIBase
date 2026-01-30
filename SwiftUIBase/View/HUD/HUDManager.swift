//
//  HUDManager.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI
import Combine

final class HUDPresenter {
    static let shared = HUDPresenter()
    
    private var loaderWindow: UIWindow?
    
    private init() {}
    
    func show() {
        DispatchQueue.main.async {
            guard self.loaderWindow == nil else { return }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.windowLevel = .alert + 1
//                window.rootViewController = UIHostingController(rootView: LoaderView())
                
                let hostingController = UIHostingController(rootView: LoaderView())
                hostingController.view.backgroundColor = .clear
                window.rootViewController = hostingController
                
                
                window.isHidden = false
                self.loaderWindow = window
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.loaderWindow?.isHidden = true
            self.loaderWindow = nil
        }
    }
}

