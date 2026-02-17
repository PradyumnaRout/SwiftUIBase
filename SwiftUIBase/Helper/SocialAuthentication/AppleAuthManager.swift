//
//  AppleAuthManager.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

// https://www.createwithswift.com/sign-in-with-apple-on-a-swiftui-application/

import Foundation
import AuthenticationServices

final class AppleAuthManager: NSObject, AuthProviderProtocol {
    private var completion: ((Result<AuthUser, Error>) -> Void)?
    
    func signIn(completion: @escaping (Result<AuthUser, Error>) -> Void) {
        self.completion = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func signOut() {}
}

// MARK: Apple authentication delegates
extension AppleAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        // ⚠️ Only available FIRST time user signs in
        let firstName = credential.fullName?.givenName
        let lastName = credential.fullName?.familyName
        let email = credential.email
        
        let userId = credential.user
        
        let user = AuthUser(
            id: userId,
            email: email,
            name: firstName,
            provider: .apple
        )
        
        completion?(.success(user))
        /**
         ⚠️ VERY IMPORTANT

         Apple only provides:

         fullName

         email

         👉 ONLY the first time the user authorizes your app.

         On subsequent logins:

         credential.fullName == nil
         credential.email == nil


         So you must store them securely the first time (Keychain / backend).
         */
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        completion?(.failure(error))
    }
}

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        UIApplication.shared.windows.first!
    }
}


//MARK: APPLE RELAY EMAIL DETAILS
/*
 ⚠️ IMPORTANT: You Only Get Email Once

 Apple sends credential.email:

 ✅ ONLY the first time the user authorizes your app

 ❌ Never again on future logins

 On subsequent logins:

 credential.email == nil


 So you MUST:

 Save it immediately (backend or Keychain)

 Link it to credential.user (the stable Apple user ID)

 🔎 How To Detect If It’s Hidden Email

 You can check:

 if let email = credential.email,
    email.contains("privaterelay.appleid.com") {
     print("User chose Hide My Email")
 }


 But usually you don't need to treat it differently.

 Just use it like normal.

 📩 Important If You Send Emails

 If you're sending emails (verification, marketing, etc.):

 You must configure Apple Private Email Relay in:

 Apple Developer → Certificates, Identifiers & Profiles → More → Configure Sign in with Apple

 Then:

 Add your email sending domain

 Add your sender email

 Verify domain (SPF/DKIM required)

 Otherwise emails to @privaterelay.appleid.com may fail.

 🧠 If You Missed Saving the Email

 If credential.email is nil and you never stored it:

 The only way to get it again is:

 User → Settings
 → Apple ID
 → Password & Security
 → Apps Using Apple ID
 → Your App
 → Stop Using Apple ID

 Then sign in again.

 🎯 Clean Production Pattern

 On first login:

 let appleId = credential.user
 let email = credential.email ?? savedEmailFromBackend


 Always treat credential.user as the primary identifier, not the email.

 Email can change.
 Apple ID user identifier does not.
 
 **************************
 
 📨 Example Scenario

 Let’s say:

 Your app domain: mycoolapp.com

 Your backend sends emails from: no-reply@mycoolapp.com

 You use SendGrid / AWS SES / Mailgun (doesn’t matter)

 Here’s what you enter.

 1️⃣ Add Email Domain

 You add:

 mycoolapp.com


 ⚠️ Not:

 https://mycoolapp.com


 ⚠️ Not:

 www.mycoolapp.com


 Just the root domain.

 If you send from subdomain like:

 no-reply@mail.mycoolapp.com


 Then add:

 mail.mycoolapp.com

 2️⃣ Add Sender Email Address

 You must add the exact email address your server uses in the "From" header.

 Example:

 no-reply@mycoolapp.com


 or

 support@mycoolapp.com


 If you send from multiple addresses, add all of them.

 3️⃣ SPF & DKIM (Very Important)

 Apple checks if your domain has proper email authentication.

 You must configure:

 SPF record (example)

 In your DNS:

 Type: TXT
 Host: @
 Value: v=spf1 include:sendgrid.net ~all


 (Replace with your provider’s SPF include)

 DKIM

 If using:

 SendGrid → Enable DKIM in SendGrid dashboard

 AWS SES → Verify domain + enable DKIM

 Mailgun → Add DKIM DNS records they give you

 Apple requires valid DKIM signing.

 🧪 What Happens If You Don’t Configure This?

 If a user chose:

 Hide My Email


 They get:

 abcd1234@privaterelay.appleid.com


 If your email relay isn’t configured:

 Your emails will silently fail

 Or Apple will reject them

 Or user never receives them

 And you won’t understand why 😅

 ✅ What a Real Setup Looks Like

 Example:

 Domain
 mycoolapp.com

 Sender
 no-reply@mycoolapp.com

 DNS

 SPF added

 DKIM added

 Domain verified in Apple Developer

 🧠 Important Architecture Advice

 Always use:

 no-reply@yourdomain.com


 Don’t send from:

 Gmail

 Outlook

 Yahoo

 Random SMTP servers

 Apple will reject many of these.
 
 
 **********************
 */
