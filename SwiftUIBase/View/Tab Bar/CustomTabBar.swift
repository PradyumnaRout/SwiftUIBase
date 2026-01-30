//
//  CustomTabBar.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI


struct CustomTabBar: View {

    @Binding var selectedTab: NavRouter.Tab
    var namespace: Namespace.ID

    var body: some View {
        HStack {
            tabButton(.home, "Home", "house")
            tabButton(.event, "Event", "calendar")
            tabButton(.scanner, "Scan", "qrcode.viewfinder")
            tabButton(.profile, "Profile", "person")
            tabButton(.setting, "Setting", "gear")
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .shadow(radius: 5)
    }

    private func tabButton(_ tab: NavRouter.Tab, _ title: String, _ icon: String) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .font(.caption)
                
                ZStack {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 3)
                    
                    if selectedTab == tab {
                        Capsule()
                            .fill(Color.blue)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "tabIndicator", in: namespace)
                    }
                }
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}
