//
//  ContentView.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(AppEnvironment.baseURl ?? "")
            Text(AppEnvironment.env ?? "")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
