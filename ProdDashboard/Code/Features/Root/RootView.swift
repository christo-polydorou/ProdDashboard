//
//  RootView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/13/24.
//

import Foundation
import SwiftUI

struct RootView: View {
    @State private var selection = 2
    
    var body: some View {
        TabView(selection: $selection) {
            SettingsView()
                .tabItem() {
                    Label("Settings", systemImage: "gear")
                }
                .tag(0)
            TaskListScreen()
                .tabItem() {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(1)
            TaskListScreen()
                .tabItem() {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(2)
            TaskListScreen()
                .tabItem() {
                    Label("Week", systemImage: "note")
                }
                .tag(3)
            DateScrollerView()
                .tabItem() {
                    Label("Month", systemImage: "calendar")
                }
                .tag(4)
            
        }
        .accentColor(.black)
    }
}

#Preview {
    RootView()
}


