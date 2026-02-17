//
//  String+Extension.swift
//  MVVMBaseProject
//
//  Created by hb on 12/07/23.
//

import Foundation
extension String {
    
    /// Localizes a string using given language from Language enum.
    /// - parameter language: The language that will be used to localized string.
    /// - Returns: localized string.
//    func localized(_ language: Language) -> String {
//        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
//        let bundle: Bundle
//        if let path = path {
//            bundle = Bundle(path: path) ?? .main
//        } else {
//            bundle = .main
//        }
//        return localized(bundle: bundle)
//    }
    
    /// Localizes a string using given language from Language enum.
    ///  - Parameters:
    ///  - language: The language that will be used to localized string.
    ///  - args:  dynamic arguments provided for the localized string.
    /// - Returns: localized string.
//    func localized(_ language: Language, args arguments: CVarArg...) -> String {
//        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
//        let bundle: Bundle
//        if let path = path {
//            bundle = Bundle(path: path) ?? .main
//        } else {
//            bundle = .main
//        }
//        return String(format: localized(bundle: bundle), arguments: arguments)
//    }
    
    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func validatedText(validationType: ValidatorType, visibility: Bool = true, optional: Bool = false, becomeFirstResponder: Bool = true) throws -> String {
        if (visibility == true && optional == false) || (visibility == true && optional == true  && !self.isEmpty) {
            let validator = VaildatorFactory.validatorFor(type: validationType)
           
            return try validator.validated(self.trim())
        } else {
            return ""
        }
    }
}

import SwiftUI

// MARK: Extensin for Color
extension String {

    func toColor(opacity: Double = 1.0) -> Color {
        let hex = self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64

        switch hex.count {

        case 3: // RGB
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )

        case 6: // RRGGBB
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        case 8: // AARRGGBB
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        default:
            return Color.clear
        }

        return Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: opacity * (Double(a) / 255)
        )
    }
}
