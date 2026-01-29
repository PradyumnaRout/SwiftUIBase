//
//  Validators.swift
//  MVVMBaseProject
//
//  Created by hb on 26/07/23.
//

import Foundation
import UIKit
import MapKit

/// Validator Error class
class ValidationError: Error {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

/// Protocol for validator
protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

/// Enum for Validator type
///
enum ValidatorType {
    /// - email: Email
    case email(message: String)
    /// - blankEmail: Email
    case blankEmail(message: String)
    /// - phone: Phone
    case phone
    /// - password: Password
    case password(message: String)
    /// - blankPassword: Password
    case blankPassword(message: String)
    /// - username: Username
    /// - requiredField: required field
    case requiredField(message: String)
    /// - firstname: Firstname
    case firstName
    /// - lastname: Lirstname
    case lastName
    /// - fullmame: fulltname
    case fullName
    /// -username : usertName
    case name
    
    case userName(message: String)
    /// -UserPin : UsertPin
    case userPin(message: String)
    /// - confirmpassword: Confirma password
    case confirmpassword(password: String, reqMessage: String, equalMessage: String )
    /// ZipCode
    case zipcode
    /// WebSite
    case website
    case listTag(message: String)
    /// - listTag: ListTagValidator
}

/// Enum for Validator methods
enum VaildatorFactory {
    /// Method to define validator type to return appropriate exception
    ///
    /// - Parameter type: Validator type
    /// - Returns: Returns exception value
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email(let message): return EmailValidator(message)
        case .blankEmail(let message): return EmailFieldBlankValidator(message)
        case .firstName: return FirstNameValidator()
        case .lastName: return LastNameValidator()
        case .fullName: return FullNameValidator()
            
        case .phone: return PhoneValidator()
        case .password(let message): return PasswordValidator(message)
        case .blankPassword(let message): return PasswordFieldBlankValidator(message)
            //        case .projectIdentifier: return ProjectIdentifierValidator()
        case .requiredField(let message): return RequiredFieldValidator(message)
            
        case .confirmpassword(let password, let message, let equalMessage): return ConfirmPasswordCheck(password, message, equalMessage)
        case .userName(let message): return UserNameValidation(message)
        case .zipcode: return ZipValidator()
        case .userPin(let message): return UserPinValidation(message)
        case .name: return NameValidator()
        case .website: return BusinessWebsiteValidator()
        case .listTag(let message): return ListTagValidator(message)
        }
    }
}

/// Class for Phone Validator
class PhoneValidator: ValidatorConvertible {
    static let maxLength = 10
    static let minLength = 8
    
    /// Validation for phone number
    ///
    /// - Parameter value: Value of textfield
    /// - Returns: returns message
    /// - Throws: throws exception if any error
    func validated(_ value: String) throws -> String {
     //   guard value.count > 0 else {throw ValidationError(AlertMessage.EmptyMobile)}
        // guard value.count < 15 else {throw ValidationError(AlertMessage.invalidMobile)}
        var aValue = value.replacingOccurrences(of: " ", with: "")
        
        if aValue.first == "0" {
            aValue.removeFirst()
        }
        let index1 = aValue.index(aValue.startIndex, offsetBy: 1)
        let index2 = aValue.index(aValue.startIndex, offsetBy: 2)
        
        if aValue.count > 3 && aValue.first == "+" && String(aValue[index1]) == "4" && String(aValue[index2]) == "4" {
            aValue.removeFirst()
            aValue.removeFirst()
            aValue.removeFirst()
        }
        if aValue.count > 3 && aValue.first == "+" && String(aValue[index1]) == "9" && String(aValue[index2]) == "1" {
            aValue.removeFirst()
            aValue.removeFirst()
            aValue.removeFirst()
        }
        
        aValue = aValue.replacingOccurrences(of: "+", with: "")
        if aValue.count > 0 {
            guard (aValue.count <= PhoneValidator.maxLength && aValue.count >= PhoneValidator.minLength)  else {throw ValidationError(AlertMessage.InvalidMobile)}
        }
       
        return value
    }
    
}

/// Class for required fields
struct RequiredFieldValidator: ValidatorConvertible {
    /// Message for fields
    private let message: String
    
    /// Init method
    ///
    /// - Parameter field: String field
    init(_ field: String) {
        message = field
    }
    
    /// Validate the string value
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError(message)
        }
        return value
    }
}

/// Password Validator
struct PasswordValidator: ValidatorConvertible {
    
    /// Message to be returned
    private let message: String
    
    /// Init Method
    ///
    /// - Parameter field: Field String
    init(_ field: String) {
        message = field
    }
    
    /// Validate Password
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(AlertMessage.EmptyPassword)}
        guard value.count >= 8 else { throw ValidationError(message) }
        guard value.count <= 50 else { throw ValidationError(message) }
        
        do {
            if !isPasswordValidated(value) {
                throw ValidationError(message)
            }
            
        } catch {
            throw ValidationError(message)
        }
        return value
    }
    
    /// Is Password valid
    ///
    /// - Parameter password: password string
    /// - Returns: returns true or false
    func isPasswordValidated(_ password: String) -> Bool {
        /// Lowercase letter
        var lowerCaseLetter: Bool = false
        /// Upper Case Letter
        var upperCaseLetter: Bool = false
        /// Is Digit
        var digit: Bool = false
        /// Is Special Character
        var special: Bool = false
        
        for char in password.unicodeScalars {
            if !lowerCaseLetter {
                lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
            }
            if !upperCaseLetter {
                upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
            }
            if !digit {
                digit = CharacterSet.decimalDigits.contains(char)
            }
            if !special {
                let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
                special = characterset.inverted.contains(char)
            }
            
        }
        if  (digit && lowerCaseLetter && upperCaseLetter && special) {
            return true
        } else {
            return false
        }
        
    }
}

/// Email Validator For Blank TextField
struct PasswordFieldBlankValidator: ValidatorConvertible {
    
    private let reqMessage: String
    init(_ requiredMessage: String) {
        reqMessage = requiredMessage
    }
    
    /// Validate Email
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(AlertMessage.EmptyPassword)}
        
        return value
    }
}


/// Email Validator
struct EmailValidator: ValidatorConvertible {
    
    private let reqMessage: String
    init(_ requiredMessage: String) {
        reqMessage = requiredMessage
    }
    
    /// Validate Email
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        
        guard !value.isEmpty else { throw ValidationError(AlertMessage.EmptyEmail)}
        guard value.count > 0 else {throw ValidationError(reqMessage)}
        
        do {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            if try NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(AlertMessage.InvalidEmail)
            }
        } catch {
            throw ValidationError(AlertMessage.InvalidEmail)
        }
        return value
    }
}

/// Email Validator For Blank TextField
struct EmailFieldBlankValidator: ValidatorConvertible {
    
    private let reqMessage: String
    init(_ requiredMessage: String) {
        reqMessage = requiredMessage
    }
    
    /// Validate Email
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(AlertMessage.EmptyEmail)}
        
        return value
    }
}


/// Full name Validator
struct FirstNameValidator: ValidatorConvertible {
    /// Validate firstname
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.EmptyFirstName)}
        
        guard value.replacingOccurrences(of: " ", with: "").count >= 3 else {
            throw ValidationError(AlertMessage.MinFirstName)
        }
        guard value.replacingOccurrences(of: " ", with: "").trim().count <= 30 else {
            throw ValidationError(AlertMessage.EmptyFirstName)
        }
        
        
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z. ].*", options: [])
            if regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count)) != nil {
                throw ValidationError(AlertMessage.EmptyFirstName)
            }
        } catch {
            throw ValidationError(AlertMessage.EmptyFirstName)
        }
        return value
    }
}

/// Full name Validator
struct LastNameValidator: ValidatorConvertible {
    /// Validate firstname
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.EmptyLastName)}
        
        guard value.replacingOccurrences(of: " ", with: "").count >= 3 else {
            throw ValidationError(AlertMessage.MinLastName)
        }
        guard value.replacingOccurrences(of: " ", with: "").trim().count <= 30 else {
            throw ValidationError(AlertMessage.EmptyLastName)
        }
        
        
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z. ].*", options: [])
            if regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count)) != nil {
                throw ValidationError(AlertMessage.EmptyLastName)
            }
        } catch {
            throw ValidationError(AlertMessage.EmptyLastName)
        }
        return value
    }
}

struct NameValidator: ValidatorConvertible {
    /// Validate firstname
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.EmptyName)}
        
        guard value.replacingOccurrences(of: " ", with: "").count >= 3 else {
            throw ValidationError(AlertMessage.MinName)
        }
        guard value.replacingOccurrences(of: " ", with: "").trim().count <= 30 else {
            throw ValidationError(AlertMessage.EmptyName)
        }
        
        
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z. ].*", options: [])
            if regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count)) != nil {
                throw ValidationError(AlertMessage.EmptyName)
            }
        } catch {
            throw ValidationError(AlertMessage.EmptyName)
        }
        return value
    }
}

struct FullNameValidator: ValidatorConvertible {
    /// Validate firstname
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.trim().count > 0 else {throw ValidationError(AlertMessage.EmptyPassword)}
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z. ].*", options: [])
            if regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count)) != nil {
                throw ValidationError(AlertMessage.InvalidLastName)
            }
        } catch {
            throw ValidationError(AlertMessage.InvalidLastName)
        }
        return value
    }
}


/// Confirm password Validator
struct ConfirmPasswordCheck: ValidatorConvertible {
    private let passwordText: String
    private let reqMessage: String
    private let eqMessage: String
    init(_ field: String, _ requiredMessage: String, _ equalMessage: String) {
        passwordText = field
        reqMessage = requiredMessage
        eqMessage = equalMessage
    }
    
    /// Validate confirm password check
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {throw ValidationError(reqMessage)}
        
        guard value == passwordText else {
            throw ValidationError(eqMessage)
        }
        return value
    }
}


/// Confirm password Validator
struct NewPasswordCheck: ValidatorConvertible {
    private let passwordText: String
    private let reqMessage: String
    private let eqMessage: String
    init(_ field: String, _ requiredMessage: String, _ equalMessage: String) {
        passwordText = field
        reqMessage = requiredMessage
        eqMessage = equalMessage
    }
    
    /// Validate confirm password check
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {throw ValidationError(reqMessage)}
        
        guard value == passwordText else {
            throw ValidationError(eqMessage)
        }
        return value
    }
}
struct UserNameValidation: ValidatorConvertible {
    private let message: String
    init(_ requiredMessage: String) {
        message = requiredMessage
    }
    
    func validated(_ value: String) throws -> String {
        // let str = ".."
        guard !value.isEmpty else { throw ValidationError(AlertMessage.EmptyUserName)}
        
        // guard value.contains(str) else {  throw ValidationError("two dots")}
        guard value.count >= 3 else { throw ValidationError(message) }
        guard value.count <= 50 else { throw ValidationError(message) }
        
        do {
            if !isUserNameValidated(value) {
                throw ValidationError(message)
            }
            
        } catch {
            throw ValidationError(message)
        }
        return value
    }
    
    /// Is Password valid
    ///
    /// - Parameter password: password string
    /// - Returns: returns true or false
    func isUserNameValidated(_ password: String) -> Bool {
        /// Lowercase letter
        var lowerCaseLetter: Bool = false
        /// Upper Case Letter
        var upperCaseLetter: Bool = false
        /// Is Digit
        var digit: Bool = false
        /// Is Special Character
        var special: Bool = false
        
        for char in password.unicodeScalars {
            if !lowerCaseLetter {
                lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
            }
            if !upperCaseLetter {
                upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
            }
            if !digit {
                digit = CharacterSet.decimalDigits.contains(char)
            }
            if !special {
                let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.")
                special = characterset.contains(char)
                
            }
            
            
        }
        if  ((digit || special ) && (upperCaseLetter || lowerCaseLetter) ) {
            return true
        } else {
            return false
        }
        
    }
    
}
struct UserPinValidation: ValidatorConvertible {
    private let message: String
    init(_ requiredMessage: String) {
        message = requiredMessage
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(AlertMessage.EmptyPin)}
        guard value.count >= 4 else { throw ValidationError(message) }
        guard value.count <= 4 else { throw ValidationError(message) }
        
        do {
            if !isPinValidated(value) {
                throw ValidationError(message)
            }
            
        } catch {
            throw ValidationError(message)
        }
        return value
    }
    
    func isPinValidated(_ password: String) -> Bool {
        
        /// Is Digit
        var digit: Bool = false
        /// Is Special Character
        
        
        for char in password.unicodeScalars where !digit {
            digit = CharacterSet.decimalDigits.contains(char)
        }
        if  (digit) {
            return true
        } else {
            return false
        }
    }
}
/// Zip Validator
struct ZipValidator: ValidatorConvertible {
    /// Validate zipcode
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
               throw ValidationError(AlertMessage.EmptyZipcode)
        }
        guard value.count >= 5 else {
            throw ValidationError(AlertMessage.InvalidZipCode)
        }
        guard value.count <= 20 else {
            throw ValidationError(AlertMessage.InvalidZipCode)
        }
        do {
            if try NSRegularExpression(pattern: "^[a-zA-Z0-9 ]{5,20}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(AlertMessage.InvalidZipCode)
            }
        } catch {
            throw ValidationError(AlertMessage.InvalidZipCode)
        }
        return value
    }
}

struct BusinessWebsiteValidator: ValidatorConvertible {
    /// Validate barname
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
               throw ValidationError(AlertMessage.EmptyLink)
        }
            do {
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                if detector.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) != nil {
                    return value
                } else {
                    throw ValidationError(AlertMessage.InvalidWebsite)
                }
            } catch {
                throw ValidationError(AlertMessage.InvalidWebsite)
            }
        }
}

struct ListTagValidator: ValidatorConvertible {
    
    private let reqMessage: String
    init(_ requiredMessage: String) {
        reqMessage = requiredMessage
    }
    
    /// Validate Email
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count >= 3 && value.count <= 25 else {throw ValidationError(reqMessage)}
        
        do {
            var allow = false
            let characterset: Set = .init("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#")
            allow = characterset.isSuperset(of: value)
            if allow {
                return value
            } else {
                throw ValidationError(AlertMessage.TitleShouldContainNumbers)
            }
        } catch {
            throw ValidationError(AlertMessage.TitleShouldContainNumbers)
        }
    }
}
