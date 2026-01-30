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
