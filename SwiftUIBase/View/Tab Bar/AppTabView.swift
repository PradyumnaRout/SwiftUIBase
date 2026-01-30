//
//  AppTabView.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

struct MainTabView: View {

//    @EnvironmentObject var router: NavRouter
    
    @Environment(NavRouter.self) var router
    @Namespace private var tabNamespace

    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .bottom) {

            TabView(selection: $router.selectedTab) {

                stack(HomeView())
                    .tag(NavRouter.Tab.home)

                stack(EventView())
                    .tag(NavRouter.Tab.event)

                stack(ScannerView())
                    .tag(NavRouter.Tab.scanner)

                stack(ProfileView())
                    .tag(NavRouter.Tab.profile)
                
                stack(SettingView())
                    .tag(NavRouter.Tab.setting)
            }
            // Custom Tab Bar
            if router.currentPath.wrappedValue.isEmpty {
                CustomTabBar(selectedTab: $router.selectedTab, namespace: tabNamespace)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: router.currentPath.wrappedValue.isEmpty)
    }

    @ViewBuilder
    private func stack<Content: View>(_ content: Content) -> some View {
        NavigationStack(path: router.currentPath) {
            content
                .navigationDestination(for: AnyScreen.self) {
                    $0.build()
                }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}





struct HomeView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {

            Button("Push Detail") {
                router.push(AnyScreen(DetailView(title: "From Home")))
            }

            Button("Go to Profile Tab") {
                withAnimation {
                    router.selectedTab = .profile
                }
            }

            Button("Open Sidebar") {
                router.openSidebarItem(.dashboard)
            }

        }
        .navigationTitle("Home")
    }
}




struct EventView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {

            Text("Event Screen")
                .font(.title)

            Button("Push Event Detail") {
                router.push(AnyScreen(DetailView(title: "Event Detail")))
            }

            Button("Pop") {
                router.pop()
            }

            Button("Reset to Root") {
                router.resetToRoot()
            }

        }
        .navigationTitle("Events")
    }
}


struct ScannerView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {

            Text("Scanner Screen")
                .font(.title)

            Button("Scan Result") {
                router.push(AnyScreen(DetailView(title: "Scan Result")))
            }

            Button("Go Home Tab") {
                withAnimation {
                    router.selectedTab = .home
                }
            }

        }
        .navigationTitle("Scanner")
    }
}


struct ProfileView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {

            Text("Profile Screen")
                .font(.title)

            Button("Edit Profile") {
                router.push(AnyScreen(DetailView(title: "Edit Profile")))
            }

            Button("Open Sidebar") {
                router.openSidebarItem(.settings)
            }

            Button("Logout (Reset Stack)") {
                router.resetToRoot()
                withAnimation {
                    router.selectedTab = .home
                }
            }

        }
        .navigationTitle("Profile")
    }
}

struct SettingView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {

            Text("Setting Screen")
                .font(.title)

            Button("Edit Profile") {
                router.push(AnyScreen(DetailView(title: "Edit Profile")))
            }

            Button("Open Sidebar") {
                router.openSidebarItem(.settings)
            }

            Button("Logout (Reset Stack)") {
                withAnimation {
                    router.resetToRoot()
                    router.selectedTab = .home
                }
            }

        }
        .navigationTitle("Setting")
    }
}


struct DetailView: View {
    let title: String
//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)

            Button("Push Next") {
                router.push(AnyScreen(Text("Another screen")))
            }

            Button("Pop") {
                router.pop()
            }
            
            Button("Change Tab From Inside") {
                router.resetAll()
                router.selectedTab = .home
            }
        }
    }
}
