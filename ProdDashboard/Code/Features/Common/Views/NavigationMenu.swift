//
//  NavigationMenu.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct NavigationMenu: View {
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(.white).frame(width: 400, height: 100, alignment: .bottom)
//            HStack {
//                Button("Settings") {
//                    // Settings Screen
//                }.modifier(SettingsButton())
//                Button("Home") {
//                    // Task List Screen
//                }.modifier(HomeButton())
//                Button("Week") {
//                    // Week Screen
//                }.modifier(WeekButton())
//                Button("Month") {
//                    // Month Screen
//                }.modifier(MonthButton())
//            }
            HStack {
//                NavigationLink(destination: TaskListScreen()){
//                    Button("Settings") {
//                        // Settings Screen
//                    }.modifier(SettingsButton())
//                }
                Button("Home") {
                    // Task List Screen
                }.modifier(HomeButton())
                Button("Week") {
                    // Week Screen
                }.modifier(WeekButton())
                Button("Month") {
                    // Month Screen
                }.modifier(MonthButton())
            }
        }
    }
}

#Preview {
    NavigationMenu()
}
