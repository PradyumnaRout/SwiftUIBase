//
//  ThemeManager.swift
//  DropShop
//
//  Created by hb on 09/02/26.
//

import SwiftUI
import Combine
import Foundation

struct ThemeModel: Codable {
    var primary: String = "#006284"
    var secondary: String = "#000000"
    var primaryText: String = "#FFFFFF"
    var secondarytext: String = "#FFFFFF"
}

class ThemeManager: ObservableObject {
    private let storageKey = "APP_THEME"
    @Published var currentTheme: ThemeModel = ThemeModel()
    
    init() {
        loadTheme()
    }
    
    var primary: Color { currentTheme.primary.toColor() }
    var secondary: Color { currentTheme.secondary.toColor() }
    var primarytext: Color { currentTheme.primaryText.toColor() }
    var secondaryText: Color { currentTheme.secondarytext.toColor() }
    
    func changeTheme(theme: ThemeModel) {
        currentTheme = theme
        saveTheme()
    }
    
    // MARK: - Persistence
    private func saveTheme() {
        guard let data = try? JSONEncoder().encode(currentTheme) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
    
    private func loadTheme() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let theme = try? JSONDecoder().decode(ThemeModel.self, from: data)
        else { return }
        
        currentTheme = theme
    }
}
