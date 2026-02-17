//
//  String+Extension.swift
//  MVVMBaseProject
//
//  Created by hb on 12/07/23.
//

import Foundation
extension String {
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
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



// Usage
/**
 func validate() {
     do {
         try Validator.validate(inputs.nickName, rules: [
             Required(message: "Please enter nickname"),
             Length(min: 3, max: 30, message: "Nickname should be minimum three characters")
         ])
         
         try Validator.validate(inputs.firstName, rules: [
             Required(message: "Please enter first name"),
             Length(min: 2, max: 30, message: "First Name should be minimum two characters")
         ])
         
         try Validator.validate(inputs.lastName, rules: [
             Required(message: "Please enter last name"),
             Length(min: 2, max: 30, message: "Last Name should be minimum two characters")
         ])
         
         try Validator.validate(inputs.email, rules: [
             Required(message: "Please enter email"),
             Email(message: "Please enter a valid email")
         ])
         
         try Validator.validate(inputs.dob, rules: [
             Required(message: "Please enter your Date Of Birth"),
         ])
         
         try Validator.validate(inputs.password, rules: [
             Required(message: "Please enter password"),
             StrongPassword(message: "Enter a valid password with 8 or more characters with a mix of letters, uppercase, lowercase, numbers & symbols")
         ])
         
         try Validator.validate(inputs.confPassword, rules: [
             Required(message: "Please enter confirm password"),
             EqualTo(other: inputs.password, message: "Password and confirm password does not match")
         ])
     } catch {
         GlobalUtility.shared.showAlert(body: error.localizedDescription)
     }
 */
