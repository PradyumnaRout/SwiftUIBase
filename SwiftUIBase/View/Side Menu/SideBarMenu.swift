//
//  SideBarMenu.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

struct SidebarMenu: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {
            Button("Dashboard") {
                router.openSidebarItem(.dashboard)
            }

            Button("Messages") {
                router.openSidebarItem(.messages)
            }

            Button("Settings") {
                router.openSidebarItem(.settings)
            }

            Button("Close") {
                router.closeSidebar()
            }
        }
        .padding()
    }
}
