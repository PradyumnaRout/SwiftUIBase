//
//  AppTabView.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI
import Combine

// A reference-type box that holds your Observable VM
final class VMHolder<T: AnyObject>: ObservableObject {
    let vm: T
    init(_ vm: T) { self.vm = vm }
}

// This will init the viewmodel of screens again and again
//struct MainTabView: View {
//
////    @EnvironmentObject var router: NavRouter
//    
//    @Environment(NavRouter.self) var router
//    @Namespace private var tabNamespace
//
//    var body: some View {
//        @Bindable var router = router
//        ZStack(alignment: .bottom) {
//
//            TabView(selection: $router.selectedTab) {
//
//                stack(HomeView())
//                    .tag(NavRouter.Tab.home)
//
//                stack(EventView())
//                    .tag(NavRouter.Tab.event)
//
//                stack(ScannerView())
//                    .tag(NavRouter.Tab.scanner)
//
//                stack(ProfileView())
//                    .tag(NavRouter.Tab.profile)
//                
//                stack(SettingView())
//                    .tag(NavRouter.Tab.setting)
//            }
//            // Custom Tab Bar
//            if router.currentPath.wrappedValue.isEmpty {
//                CustomTabBar(selectedTab: $router.selectedTab, namespace: tabNamespace)
//                    .transition(.move(edge: .bottom))
//            }
//        }
//        .animation(.easeInOut, value: router.currentPath.wrappedValue.isEmpty)
//    }
//
//    @ViewBuilder
//    private func stack<Content: View>(_ content: Content) -> some View {
//        NavigationStack(path: router.currentPath) {
//            content
//                .navigationDestination(for: AnyScreen.self) {
//                    $0.build()
//                }
//        }
//        .toolbar(.hidden, for: .tabBar)
//    }
//}



// Better Approach
//struct MainTabView: View {
//    @Environment(NavRouter.self) var router
//    @Namespace private var tabNamespace
//    @State private var visitedTabs: Set<NavRouter.Tab> = [.home]
//
//    var body: some View {
//        @Bindable var router = router
//        ZStack(alignment: .bottom) {
//            ZStack {
//                if visitedTabs.contains(.home) {
//                    stack(HomeView(), tab: .home)
//                }
//                if visitedTabs.contains(.event) {
//                    stack(EventView(), tab: .event)
//                }
//                if visitedTabs.contains(.scanner) {
//                    stack(ScannerView(), tab: .scanner)
//                }
//                if visitedTabs.contains(.profile) {
//                    stack(ProfileView(), tab: .profile)
//                }
//                if visitedTabs.contains(.setting) {
//                    stack(SettingView(), tab: .setting)
//                }
//            }
//
//            CustomTabBar(selectedTab: $router.selectedTab, namespace: tabNamespace)
//        }
//        .onChange(of: router.selectedTab) { _, newTab in
//            visitedTabs.insert(newTab)
//        }
//    }
//
//    @ViewBuilder
//    private func stack<Content: View>(_ content: Content, tab: NavRouter.Tab) -> some View {
//        NavigationStack(path: router.currentPath(for: tab)) {
//            content
//                .navigationDestination(for: AnyScreen.self) {
//                    $0.build()
//                }
//        }
//        .opacity(router.selectedTab == tab ? 1 : 0)
//        .allowsHitTesting(router.selectedTab == tab)
//        .toolbar(.hidden, for: .tabBar)
//    }
//}


// Much Better
struct MainTabView: View {
    
    @Environment(NavRouter.self) var router
    @Namespace private var tabNamespace
    @State private var visitedTabs: Set<NavRouter.Tab> = [.home]

    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .bottom) {

            TabView(selection: $router.selectedTab) {

                stack(HomeView(), tab: .home)
                    .tag(NavRouter.Tab.home)

                stack(EventView(), tab: .event)
                    .tag(NavRouter.Tab.event)

                stack(ScannerView(), tab: .scanner)
                    .tag(NavRouter.Tab.scanner)

                stack(ProfileView(), tab: .profile)
                    .tag(NavRouter.Tab.profile)
                
                stack(SettingView(), tab: .setting)
                    .tag(NavRouter.Tab.setting)
            }
            // Custom Tab Bar
            CustomTabBar(selectedTab: $router.selectedTab, namespace: tabNamespace)
        }
    }

    @ViewBuilder
    private func stack<Content: View>(_ content: Content, tab: NavRouter.Tab) -> some View {
        NavigationStack(path: router.currentPath(for: tab)) {
            content
                .navigationDestination(for: AnyScreen.self) {
                    $0.build()
                }
        }
        .opacity(router.selectedTab == tab ? 1 : 0)
        .allowsHitTesting(router.selectedTab == tab)
        .toolbar(.hidden, for: .tabBar)
    }
}





struct HomeView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router
//    @State private var vm: HomeViewModel = HomeViewModel()
    @StateObject private var holder = VMHolder(HomeViewModel())
    private var vm: HomeViewModel { holder.vm }

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
            
            VStack {
                Text(vm.title)  // ✅ Will update to "World" when button tapped
                
                Button("Change") {
                    vm.changeTitle()
                }
            }

        }
        .navigationTitle("Home")
    }
}

@Observable
class HomeViewModel {
    var title = "Hello"
    init() {
        print("=======Home Init========")
    }
    
    func changeTitle() {
        title = "World"
    }
}




struct EventView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router
//    @State private var vm: EventViewModel = EventViewModel()
    @StateObject private var holder = VMHolder(EventViewModel())
    private var vm: EventViewModel { holder.vm }

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

@Observable
class EventViewModel {
    init() {
        print("=======Event Init========")
    }
}


struct ScannerView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router
//    @State private var vm: ScannerViewModel = ScannerViewModel()
    @StateObject private var holder = VMHolder(ScannerViewModel())
    private var vm: ScannerViewModel { holder.vm }

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

@Observable
class ScannerViewModel {
    init() {
        print("=======Scanner Init========")
    }
}


struct ProfileView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router
//    @State private var vm: ProfileViewModel = ProfileViewModel()
    @StateObject private var holder = VMHolder(ProfileViewModel())
    private var vm: ProfileViewModel { holder.vm }

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

@Observable
class ProfileViewModel {
    init() {
        print("=======Profile Init========")
    }
}

struct SettingView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router
//    @State private var vm: SettingViewModel = SettingViewModel()
    @StateObject private var holder = VMHolder(SettingViewModel())
    private var vm: SettingViewModel { holder.vm }


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

@Observable
class SettingViewModel {
    init() {
        print("=======Setting Init========")
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
