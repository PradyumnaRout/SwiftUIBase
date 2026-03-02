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

extension View {
    func onChange<T: Equatable>(data: T, perform action: @escaping (T) -> Void) -> some View {
        self.modifier(ChangeValue(data: data, action: action))
    }
}

struct ChangeValue<T: Equatable>: ViewModifier {
    var data: T
    var action: ((T) -> Void)
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .onChange(of: data) { oldValue, newValue in
                    action(newValue)
                }
        } else {
            content
                .onChange(of: data) { newValue in
                    action(newValue)
                }
        }
    }
}
