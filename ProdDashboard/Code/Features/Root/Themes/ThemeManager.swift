//
//  ThemeManager.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import Foundation

enum ThemeManager {
    static let themes: [Theme] = [BaseTheme(), ForestTheme(), LightTheme()]
    
    static func getTheme(_ theme: Int) -> Theme {
        Self.themes[theme]
    }
}
