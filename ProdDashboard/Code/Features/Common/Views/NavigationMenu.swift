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
            Rectangle().foregroundColor(.clear).background(.white).frame(width: 400, height: 80, alignment: .bottom)
            HStack(spacing: 30) {
                Button(action: {
                    
                }) {
                    Text("Settings")
                        .font(.system(size: 14)) // Change font size
                        .foregroundColor(.black) // Change text color
                }.modifier(SettingsButton())
                
                Button(action: {
                    // Month Screen
                }) {
                    Text("Stats")
                        .font(.system(size: 14)) // Change font size
                        .foregroundColor(.black) // Change text color
                }.modifier(StatsButton())
                
                Button(action: {
                    // Task List Screen
                }) {
                    Text("Home")
                        .font(.system(size: 14)) // Change font size
                        .foregroundColor(.black) // Change text color
                }.modifier(HomeButton())
                
                Button(action: {
                    // Week Screen
                }) {
                    Text("Week")
                        .font(.system(size: 14)) // Change font size
                        .foregroundColor(.black) // Change text color
                }.modifier(WeekButton())
                
                Button(action: {
                    // Month Screen
                }) {
                    Text("Month")
                        .font(.system(size: 14)) // Change font size
                        .foregroundColor(.black) // Change text color
                }.modifier(MonthButton())
            }
                
                
//                
//                Button("Settings") {
//                    SettingsView()
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

        }
    }
}

#Preview {
    NavigationMenu()
}
