//
//  AlertManager.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import SwiftUI

struct AppAlert: Equatable {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let onPrimaryAction: (() -> Void)?
    let onSecondaryAction: (() -> Void)?
    
    static func == (lhs: AppAlert, rhs: AppAlert) -> Bool {
        lhs.message == rhs.message
    }
}

@Observable
@MainActor
final class AlertManager {
    var alert: AppAlert?
    
    func show(_ alert: AppAlert) {
        self.alert = alert
    }
    
    func dismiss() {
        alert = nil
    }
}
