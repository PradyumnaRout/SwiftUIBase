//
//  LoaderView.swift
//  MVVMBaseProject
//
//  Created by hb on 18/07/23.
//

import SwiftUI

struct LoaderView2: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                LottieView(name: "wifiLoading", loopMode: .loop)
//                    .frame(width: 150, height: 150)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .background(
                Color.black.opacity(0.3)
            )
        }
    }
}
