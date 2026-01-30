//
//  AlertManager.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import SwiftUI


class AlertManager {
    static  let shared = AlertManager()
    private var alertWindow: UIWindow?

    func showAlert(title:String, message:String, image: UIImage? = nil, cancelStr:String, confirmStr:String, cancel :(()->())? = nil, confirm :(()->())? = nil) {
        
        let aAlertView = CustomAlert(
            title: title,
            message: message,
            leftActionText: cancelStr,
            rightActionText: confirmStr,
            image: image) {
                self.hide()
                cancel?()
            } rightButtonAction: {
                self.hide()
                confirm?()
            }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let hostingController = UIHostingController(rootView: aAlertView)
            hostingController.view.backgroundColor = .clear
            window.windowLevel = .alert + 1
            
            window.rootViewController = hostingController
            
            
            window.isHidden = false
            self.alertWindow = window
        }
        
    }
    func hide() {
        DispatchQueue.main.async {
            self.alertWindow?.isHidden = true
            self.alertWindow = nil
        }
    }
}





struct ViewShowAlert: View {
    
    var body: some View {
        VStack {
            Button("Show") {
                AlertManager.shared
                    .showAlert(
                        title: "Alert",
                        message: "Are you sure you want to verify the new email for this account?",
                        cancelStr: "No",
                        confirmStr: "Verify") {
                            print("Cancel Clicked")
                        } confirm: {
                            print("Verify Clicked")
                        }
            }
        }
    }
}

#Preview {
    ViewShowAlert()
}
