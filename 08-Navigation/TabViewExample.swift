//
//  TabViewExample.swift
//  TabView with an independent NavigationStack per tab.
//

import SwiftUI

struct TabViewExample: View {
    // Track the selected tab so you can switch tabs programmatically.
    @State private var selection: Tab = .home

    enum Tab { case home, search, profile }

    var body: some View {
        TabView(selection: $selection) {

            // Each tab gets its OWN NavigationStack so their back-stacks are independent.
            NavigationStack {
                Text("Home").navigationTitle("Home")
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(Tab.home)

            NavigationStack {
                BasicSearch()   // reuse the search snippet
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(Tab.search)

            NavigationStack {
                Text("Profile").navigationTitle("Profile")
            }
            .tabItem { Label("Profile", systemImage: "person") }
            .tag(Tab.profile)
        }
    }
}

#Preview {
    TabViewExample()
}
