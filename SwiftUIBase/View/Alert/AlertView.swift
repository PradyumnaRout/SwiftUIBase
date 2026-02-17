//
//  AlertView.swift
//  DropShop
//
//  Created by hb on 13/02/26.
//

import SwiftUI

struct AlertView: View {
    
    @EnvironmentObject private var theme: ThemeManager
    
    let alert: AppAlert
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(alert.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(theme.secondary)
                
                Rectangle()
                    .fill(theme.secondary.opacity(0.5))
                    .frame(height: 1)
                
                Text(alert.message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(theme.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 15) {
                    if let secondaryBtnTitle = alert.secondaryButtonTitle {
                        Button {
                            onDismiss()
                            alert.onSecondaryAction?()
                        } label: {
                            Text(secondaryBtnTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(theme.secondary)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button {
                        onDismiss()
                        alert.onPrimaryAction?()
                    } label: {
                        Text(alert.primaryButtonTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(theme.primarytext)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(.white, in: .rect(cornerRadius: 15))
            .padding(.horizontal)
        }
    }
}

#Preview {
    AlertView(alert: .init(
        title: "Face Not Recognized",
        message: "Face ID is currently not enabled on this device. You can enable it in your device settings or continue with your passcode.",
        primaryButtonTitle: "Cancel",
        secondaryButtonTitle: "Try Again",
        onPrimaryAction: nil,
        onSecondaryAction: nil
    ), onDismiss: {}
    )
    .environmentObject(ThemeManager())
}
