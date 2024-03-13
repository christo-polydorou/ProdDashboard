//
//  WrapperView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import SwiftUI

// invisible view that calls the navigation view, and thus the rest of the views, with the specified color theme
struct WrapperView: View {
    @EnvironmentObject var dataSource: DataSource
    @State private var selectedTab: Int = 1
    
    var body: some View {

        ForEach(0..<ThemeManager.themes.count, id: \.self) { theme in
            if ThemeManager.themes[theme].themeName == dataSource.selectedTheme.themeName {
                RootView(selectedTab: $selectedTab)
            }
        }
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
            .environmentObject(DataSource())
    }
}
