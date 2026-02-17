//
//  LanguageManager.swift
//  DropShop
//
//  Created by hb on 04/02/26.
//

import Foundation
import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    @Published var refreshID = UUID()
    
    var currentLocale: Locale {
        // 1️⃣ If user selected language inside app
        if !currentLanguage.isEmpty,
           SupportedLanguage(rawValue: currentLanguage) != nil {
            return Locale(identifier: currentLanguage)
        }
        
        // No app-level selection — use device language
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        if SupportedLanguage(rawValue: deviceLanguage) != nil {
            return Locale.current
        }
        
        // Device language not supported — fall back to English
        return Locale(identifier: "en")
        
    }
    
    private init() {
        // Check if user has previously selected a language
        if let savedLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first {
            self.currentLanguage = savedLanguage
        } else {
            // Use device language if supported, otherwise fall back to English
            let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            self.currentLanguage = SupportedLanguage(rawValue: deviceLanguage) != nil ? deviceLanguage : "en"
        }
        
        print("🌍 LanguageManager initialized with language: \(String(describing: currentLanguage))")
    }
    
    func setLanguage(_ language: String) {
        print("🌍 Changing language to: \(String(describing: language))")
        currentLanguage = language
        refreshID = UUID()
    }
}

// Go Back to Device Language
//LanguageManager.shared.setLanguage("")

enum SupportedLanguage: String, CaseIterable {
    case de = "de"
    case en = "en"
    case fr = "fr"
    case it = "it"
    
    var title: String {
        switch self {
        case .de:
            return "German"
        case .en:
            return "English"
        case .fr:
            return "French"
        case .it:
            return "Italian"
        }
    }
    
//    var image: ImageResource {
//        switch self {
//        case .de:
//            return .german
//        case .en:
//            return .english
//        case .fr:
//            return .french
//        case .it:
//            return .italian
//        }
//    }
}
