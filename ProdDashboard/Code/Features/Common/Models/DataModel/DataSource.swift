//
//  DataSource.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import SwiftUI

class DataSource: ObservableObject {
    @AppStorage("selectedTheme") var selectedThemeAS = 1 {
        didSet {
            updateTheme()
        }
    }
    
    init() {
        updateTheme()
    }
    
    @Published var selectedTheme: Theme = ForestTheme()
    
    func updateTheme() {
        selectedTheme = ThemeManager.getTheme(selectedThemeAS)
    }
}
