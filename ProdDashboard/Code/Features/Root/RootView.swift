//
//  RootView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/13/24.
//

import Foundation
import SwiftUI

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
//            TaskListScreen()
//                .tabItem() {
//                    Label("Stats", systemImage: "chart.bar")
//                }
//                .tag(1)
            TaskListScreen()
                .tabItem() {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(2)
            WeekView()
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
        .accentColor(Color("TabView"))

    }
}

//#Preview {
//    RootView()
//        .environmentObject(DataSource())
//        .environmentObject(DateHolder())
//}
