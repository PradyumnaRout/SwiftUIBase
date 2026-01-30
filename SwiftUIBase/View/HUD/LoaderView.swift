//
//  LoaderView.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

struct LoaderView: View {
    
    let ringSize: CGFloat = 40
    @State private var rotationAngle = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
//                LottieView(name: "Loading", loopMode: .loop)
                    .frame(width: 200, height: 200)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

#Preview {
    LoaderView()
}

