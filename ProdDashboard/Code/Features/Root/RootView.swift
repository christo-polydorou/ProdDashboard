//
//  RootView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/13/24.
//

import Foundation
import SwiftUI

// defines the navigation bar at the bottom of the screen
struct RootView: View {
    @State private var selection = 1
    
    @Binding var selectedTab: Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem() {
                    Label("Settings", systemImage: "gear")
                }
                .tag(0)

            TaskListScreen()
                .tabItem() {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)
            WeekView()
                .tabItem() {
                    Label("Week", systemImage: "note")
                }
                .tag(2)
            DateScrollerView()
                .tabItem() {
                    Label("Month", systemImage: "calendar")
                }
                .tag(3)
            
        }
        .accentColor(Color("TabView"))

    }
}


