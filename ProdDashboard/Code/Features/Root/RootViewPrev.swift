//
//  RootViewPrev.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import Foundation
import SwiftUI

struct RootViewPrev: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            SettingsView()
                .tabItem(){
                    Label("Settings", systemImage: "gear")
                }
                .tag(0)
//            TaskListScreen()
//                .tabItem() {
//                    Label("Stats", systemImage: "chart.bar")
//                }
//                .tag(1)
            TaskListScreen()
                .tabItem(){
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)
            WeekView()
                .tabItem(){
                    Label("Week", systemImage: "note")
                }
                .tag(2)
            DateScrollerView()
                .tabItem(){
                    Label("Month", systemImage: "calendar")
                }
                .tag(3)
            
        }
        .accentColor(.black)
        .background(.black)
    }
}

#Preview {
    RootViewPrev()
        .environmentObject(DataSource())
        .environmentObject(DateHolder())
}

