//
//  BaseNavigationView.swift
//  MVVMBaseProject
//
//  Created by hb on 20/07/23.
//

import SwiftUI

struct BaseNavigationView<Content>: View where Content: View {
    
    let title: String
    let content: Content
    
    var body: some View {
        NavigationView {
            ZStack {
                content
            }
            .navigationBarTitle(title, displayMode: .automatic)
        }
    }
}
