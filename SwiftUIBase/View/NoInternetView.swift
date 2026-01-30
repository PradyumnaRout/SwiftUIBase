//
//  NoInternetView.swift
//  MVVMBaseProject
//
//  Created by hb on 17/07/23.
//

import SwiftUI

struct NoInternetView: View {
    /// Required for localisation e.g. "Hello".localized(language)
    var body: some View {
        VStack {
            Image("appLogo")
                .aspectRatio(contentMode: .fit)
                .padding()
//            LottieView(name: "wifiLoading", loopMode: .loop)
                .frame(width: 150, height: 150)
            Text(AppKeyWord.NoInternetConnection)
                .font(Font(CTFont(.alertHeader, size: 25)))
                .padding(20)
                .multilineTextAlignment(.center)
            HStack {
                Button(AppKeyWord.CloseApp) {
                    exit(0)
                }
                .background(
                    GeometryReader { geomatery in
                        Color.blue
                            .frame(width: geomatery.size.width, height: 1) // underline's height
                            .offset(y: geomatery.size.height + 10) // underline's y pos
                    }
                )
                .padding(30)
                Button(AppKeyWord.OpenSettings) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .background(
                    GeometryReader { geomatery in
                        Color.blue
                            .frame(width: geomatery.size.width, height: 1) // underline's height
                            .offset(y: geomatery.size.height + 10) // underline's y pos
                    }
                )
                .padding(30)
            }
        }
    }
}
