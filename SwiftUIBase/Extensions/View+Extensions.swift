//
//  View+Extensions.swift
//  MVVMBaseProject
//
//  Created by hb on 20/07/23.
//

import Foundation
import SwiftUI

extension View {
    
    /// View extension function to dismiss keyboard.
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    func showAlert(title: String, message: String, cancelButtonTitle: String, secondaryButtonTitle: String? = "", isPresented: Binding<Bool>, action: ()) -> some View {
        if !(secondaryButtonTitle?.trim() ?? "").isEmpty {
            return self.alert(isPresented: isPresented) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    primaryButton: .default(Text(cancelButtonTitle)),
                    secondaryButton: .default(Text(secondaryButtonTitle ?? "")) {
                        action
                    }
                )
            }
        } else {
            return self.alert(isPresented: isPresented) {
                Alert(
                    title: Text(""),
                    message: Text(message),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
}
