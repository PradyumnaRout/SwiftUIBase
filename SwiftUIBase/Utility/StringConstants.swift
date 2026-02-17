//
//  StringConstants.swift
//  MVVMBaseProject
//
//  Created by hb on 12/07/23.
//

import Foundation
// Few empty strings added for localisation to redraw view using @AppStorage

struct AppKeyWord {
    static let EnterName = "Enter Name"
    static let UpdateName = "Update Name"
    static let AddUser = "Add User"
    static let ChangeLanguageToEnglish = "Change Language To English"
    static let ChangeLanguageToFrench = "Change Language To French"
    static let Users = "Users"
    static let Favorites = "Favorites"
    static let Chats = "Chats"
    static let Profile = "Profile"
    static let Currently = "Currently"
    static let IsUnder = "is under maintenance, please visit again after sometime"
    static let NoInternetConnection = "No Internet Connection"
    static let CloseApp = "Close App"
    static let OpenSettings = "Open Settings"
    static var Ok = ""
    static var Cancel = ""
    static var OkWithText = "Ok"
    static var CancelWithText = "Cancel"
    static let ViewLogs = "View Logs"
    static let FirebaseCrash = "Firebase Crash"
    static let UpdateNow = "Update Now"
    static let OpenBottomsheet = "Open Bottomsheet"
    static let LoginAPICall = "Login API Call"
}

struct AlertMessage {
    static let PleaseEnterName = "Please Enter Name"
    static let InternetError = "Please check your internet connection and try again"
    static let DefaultError = "Something went wrong, Please try again"
    static let ResetPasswordNotMatch = "New Password and Confirm Password does not match"
    static let EmptyPassword = "Please provide the password"
    static let EmptyEmail = "Please provide an email address"
    static let EmptyEmailAndUserName = "Please provide a username or an email address"
    static let InvalidEmail = "Invalid email address, please try again with a valid email"
    static let EmptyConfirmPassword = "Please provide the confirm password"
    static let InvalidPassword = "Enter a valid password with 8 or more characters with a mix of letters, uppercase,lowercase, numbers & symbols"
    static let InvalidUsername = "Invalid username, please try again with valid username"
    static let NewPassword = "Please provide new password"
    static let InvalidLastName = "Invalid last name, please try again with a  valid last name"
    static let InvalidFirstName = "Invalid first name, please try again with a  valid first name"
    static let InvalidPasswordLogIN = "Invalid password, please try again"
    static let InvalidZipCode = "Invalid zipcode, please try again"
    static let PasswordNotMatch = "Password and Confirm Password does not match"
    static let SelectTC = "Please accept Terms & Conditions"
    static let SelectPP = "Please accept Privacy Policy"
    static let InvalidTC_PP = "Please accept Terms & Conditions and Privacy Policy"
    static let WrongPin = "You have entered wrong pin"
    static let InvalidTempPass = "The password you entered is invalid"
    static let MinUserName = "Username should be distinctive, memorable and should be at least 3 char long"
    static let MinFirstName = "First name should be atleast 3 char long"
    static let MinName = "Name should be atleast 3 char long"
    static let MinLastName = "Last name should be atleast 3 char long"
    static let InvalidPin = "Your pin should be 4 digits"
    static let EmptyPin = "Please provide the pin"
    static let EmptyUserName = "Please provide an username"
    static let EmptyConfirmPin = "Please provide confirm pin"
    static let PinNotMatch = "Pin and Confirm Pin does not match"
    static let TemporaryPassword = "Please provide temporary password"
    static let InvalidAge = "Age should be more than 17"
    static let EmptyFirstName = "Please provide your first name as per your Id"
    static let EmptyName = "Please provide your name"
    static let EmptyLastName = "Please provide your last name as per your Id"
    static let Emptyphone = "Please provide your phone number"
    static let EmptyDob = "Please provide your DOB"
    static let EmptyAddress = "Please provide your Address as per your Id"
    static let EmptyZipcode = "Please provide your zipcode"
    static let EmptyLink = "Please enter a Link"
    static let InvalidWebsite = "You have entered a invalid link"
    static let InvalidMobile = "Invalid phone number, please provide a valid phone number"
    static let EmptyMobile = "Please provide your phone number"
    static let InvalidOldPassword = "Old Password (Min 8 Characters)"
    static let InvalidNewPassword = "New Password (Min 8 Characters)"
    static let InvalidRePassword = "Re-Password (Min 8 Characters)"
    static let InvalidConfirmPassword = "Confirm Password (Min 8 Characters)"
    static let TermsCondition = "Please accept terms & conditions"
    static let EnterCurrentPasscode = "Enter pim"
    static let EnterPasscode = "Please enter a new PIN"
    static let NewPin = "Please enter a new pin"
    static let ReEnterPasscode = "Confirm your pin"
    static let TitleShouldContainNumbers = "Title should contain only characters"
    static var AlertTitle = ""
    static var AlertMessage = ""
    static var ToastTitle = ""
    static var toastSubTitle = ""
    static let PleaseTryAgain = "Please Try Again"
    static let NoDataFound = "No Data Found"
    static let NewVersionAvailable = "New Version Available"
    static let ThereIsNewerVersion = "There Is Newer Version Available for Download! Please Update the App by Visiting the Apple Store."
}


// MARK: For multiple language change
struct LocalizedString {
    let key: String
    
    func callAsFunction(_ manager: LanguageManager = .shared) -> String {
        localizedString(for: key, locale: manager.currentLocale)
    }
    // Call Like
    // StringConst.enableBiometric(languageManager)
    // StringConst.enableBiometric.callAsFunction(languageManager)
    // No trick — just syntax sugar.


    
    private func localizedString(for key: String, locale: Locale) -> String {
        let language = locale.language.languageCode?.identifier ?? "en"
        
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            print("⚠️ Failed to find bundle for language: \(language)")
            return key
        }
        
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        print("🔤 Localized '\(key)' to '\(localizedString)' for \(language)")
        return localizedString
    }
}

struct StringConst {
    static let welcomeKey = LocalizedString(key: "Welcome Back")
    static let signInMessage = LocalizedString(key: "Sign in to your DropShop account")
    static let addressLine1Header =
        LocalizedString(key: NSLocalizedString("Address line 1", comment: ""))

    static let addressLine1Plc =
        LocalizedString(key: NSLocalizedString("Enter address line 1", comment: ""))

    static let addressLine2Header =
        LocalizedString(key: NSLocalizedString("Address line 2", comment: ""))

    static let addressLine2Plc =
        LocalizedString(key: NSLocalizedString("Enter address line 2", comment: ""))

    static let postalCodeHeader =
        LocalizedString(key: NSLocalizedString("Postal code", comment: ""))

    static let postalCodePlc =
        LocalizedString(key: NSLocalizedString("Enter postal code", comment: ""))

    static let cityHeader =
        LocalizedString(key: NSLocalizedString("City", comment: ""))

    static let cityPlc =
        LocalizedString(key: NSLocalizedString("Enter city", comment: ""))

    static let stateHeader =
        LocalizedString(key: NSLocalizedString("State / Province / Region", comment: ""))

    static let statePlc =
        LocalizedString(key: NSLocalizedString("Enter state / province / region", comment: ""))

    static let countryHeader =
        LocalizedString(key: NSLocalizedString("Country", comment: ""))

    static let countryPlc =
        LocalizedString(key: NSLocalizedString("Enter country", comment: ""))
    
    static let phoneNumberHeader =
        LocalizedString(key: NSLocalizedString("Phone number", comment: ""))
    
    static let phoneNumberPlc =
        LocalizedString(key: NSLocalizedString("Enter phone number", comment: ""))
    
    static let genderPlc =
        LocalizedString(key: NSLocalizedString("Gender", comment: ""))
    
    static let select =
        LocalizedString(key: NSLocalizedString("Select", comment: ""))
    
    static let searchOrders =
        LocalizedString(key: NSLocalizedString("Search orders...", comment: ""))
    
    static let currentPassword =
        LocalizedString(key: NSLocalizedString("Current password", comment: ""))
    
    static let newPassword =
        LocalizedString(key: NSLocalizedString("New password", comment: ""))
    
    static let confirmPassword =
        LocalizedString(key: NSLocalizedString("Confirm new password", comment: ""))
    
    static let yourUniqueId =
        LocalizedString(key: NSLocalizedString("Your unique ID", comment: ""))
    
    static let enterUniqueId =
        LocalizedString(key: NSLocalizedString("Enter unique ID", comment: ""))
    
    static let backToWalletTitle =
        LocalizedString(key: NSLocalizedString("Back To Wallet", comment: ""))
    
    static let addToWalletTitle =
        LocalizedString(key: NSLocalizedString("Add To Wallet", comment: ""))
    
    static let scanNow =
        LocalizedString(key: NSLocalizedString("Scan Now", comment: ""))
    static let scanEligibleProduct =
        LocalizedString(key: NSLocalizedString("Scan Eligible Product", comment: ""))
    static let startGame =
        LocalizedString(key: NSLocalizedString("Start Game", comment: ""))
}


// Usage
// @EnvironmentObject var languageManager: LanguageManager
// StringConst.welcomeKey(languageManager)
