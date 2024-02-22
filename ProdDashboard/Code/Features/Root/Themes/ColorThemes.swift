//
//  ColorThemes.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import Foundation
import SwiftUI

struct BaseTheme: Theme {
    var accentColor = Color("base.accentColor")
    var backgroundColor = Color("base.background")
    var backgroundColorAlt = Color("base.background")
    var buttonColor = Color("base.button")
    var themeName = "Base"
    
}

struct ForestTheme: Theme {
    var accentColor = Color("forest.accentColor")
    var backgroundColor = Color("forest.background")
    var backgroundColorAlt = Color("forest.backgroundAlt")
    var buttonColor = Color("forest.button")
    var themeName = "Forest"
}

struct LightTheme: Theme {
    var accentColor = Color("AccentColor")
    var backgroundColor = Color("light.background")
    var backgroundColorAlt = Color("light.background")
    var buttonColor = Color("light.button")
    var themeName = "Light"
}

