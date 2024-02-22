//
//  WrapperView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import SwiftUI

struct WrapperView: View {
    @EnvironmentObject var dataSource: DataSource
    @State private var selectedTab: Int = 1
    
    var body: some View {
//        @State var selectedThemeID: Int = 0
//        @Binding var intBinding: Int
//
        ForEach(0..<ThemeManager.themes.count, id: \.self) { theme in
//            var selectedThemeID: Int = 0
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
