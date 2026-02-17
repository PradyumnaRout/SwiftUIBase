//
//  NavigationWrapper.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import Foundation
import SwiftUI
import Combine
import Observation

enum AppFlow {
    case splash
    case auth
    case main
}

struct AnyScreen: Hashable, Identifiable {
    let id: UUID
    private let viewBuilder: () -> AnyView

    init<V: View>(_ view: V) {
        self.id = UUID()
        self.viewBuilder = { AnyView(view) }
    }

    func build() -> AnyView {
        viewBuilder()
    }

    static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


//final class NavRouter: ObservableObject {
//    
//    @Published var appFlow: AppFlow = .splash
//
//    enum Tab: Hashable {
//        case home, event, scanner, profile, setting
//    }
//
//    enum SidebarItem: Hashable {
//        case dashboard
//        case messages
//        case settings
//        case profile
//    }
//
//    // MARK: - State
//    @Published var selectedTab: Tab = .home
//    @Published var selectedSidebarItem: SidebarItem? = nil
//
//    // MARK: - Navigation stacks per tab
//    @Published private var routes: [Tab: NavigationPath] = [
//        .home: NavigationPath(),
//        .event: NavigationPath(),
//        .scanner: NavigationPath(),
//        .profile: NavigationPath(),
//        .setting: NavigationPath()
//    ]
//
//    // MARK: - Access current path
//    var currentPath: Binding<NavigationPath> {
//        Binding(
//            get: { self.routes[self.selectedTab] ?? NavigationPath() },
//            set: { self.routes[self.selectedTab] = $0 }
//        )
//    }
//
//    // MARK: - Actions
//    func push(_ screen: AnyScreen) {
//        routes[selectedTab]?.append(screen)
//    }
//
//    func pop() {
//        guard var path = routes[selectedTab], !path.isEmpty else { return }
//        path.removeLast()
//        routes[selectedTab] = path
//    }
//
//    func resetToRoot() {
//        routes[selectedTab] = NavigationPath()
//    }
//
//    // MARK: - Tab control
//    func switchTab(_ tab: Tab) {
//        selectedTab = tab
//    }
//
//    // MARK: - Sidebar control
//    func openSidebarItem(_ item: SidebarItem) {
//        selectedSidebarItem = item
//        resetToRoot()
//    }
//    
//    func closeSidebar() {
//        selectedSidebarItem = nil
//    }
//
//    // MARK: - Reset everything
//    func resetAll() {
//        for tab in routes.keys {
//            routes[tab] = NavigationPath()
//        }
//    }
//    
//    // App Flow
//    func goToMainApp() {
//        appFlow = .main
//    }
//    
//    func goToAuth() {
//        appFlow = .auth
//    }
//}

@Observable
final class NavRouter {
    
    var appFlow: AppFlow = .splash

    enum Tab: LocalizedStringResource, Hashable {
        case home, event, scanner, profile, setting
        
        var name: String {
            switch self {
            case .home:
                return "Home"
            case .event:
                return "Event"
            case .scanner:
                return "Scanner"
            case .profile:
                return "Profile"
            case .setting:
                return "Setting"
            }
        }
    }

    enum SidebarItem: LocalizedStringResource, Hashable {
        case dashboard
        case messages
        case settings
        case profile
    }

    // MARK: - State
    var selectedTab: Tab = .home
    var selectedSidebarItem: SidebarItem? = nil

    // MARK: - Navigation stacks per tab
    private var routes: [Tab: NavigationPath] = [
        .home: NavigationPath(),
        .event: NavigationPath(),
        .scanner: NavigationPath(),
        .profile: NavigationPath(),
        .setting: NavigationPath()
    ]

    // MARK: - Access current path
    var currentPath: Binding<NavigationPath> {
        Binding(
            get: { self.routes[self.selectedTab] ?? NavigationPath() },
            set: { self.routes[self.selectedTab] = $0 }
        )
    }

    // MARK: - Actions
    func push(_ screen: AnyScreen) {
        routes[selectedTab]?.append(screen)
    }

    func pop() {
        guard var path = routes[selectedTab], !path.isEmpty else { return }
        path.removeLast()
        routes[selectedTab] = path
    }

    func resetToRoot() {
        routes[selectedTab] = NavigationPath()
    }

    // MARK: - Tab control
    func switchTab(_ tab: Tab) {
        selectedTab = tab
    }

    // MARK: - Sidebar control
    func openSidebarItem(_ item: SidebarItem) {
        selectedSidebarItem = item
        resetToRoot()
    }
    
    func closeSidebar() {
        selectedSidebarItem = nil
    }

    // MARK: - Reset everything
    func resetAll() {
        for tab in routes.keys {
            routes[tab] = NavigationPath()
        }
    }
    
    // App Flow
    func goToMainApp() {
        appFlow = .main
    }
    
    func goToAuth() {
        appFlow = .auth
    }
}
