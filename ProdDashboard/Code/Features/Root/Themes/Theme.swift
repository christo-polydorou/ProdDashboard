//
//  Theme.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import SwiftUI

protocol Theme {
    var accentColor: Color { get }
    var backgroundColor: Color { get }
    var backgroundColorAlt: Color { get }
    var buttonColor: Color { get }
    var themeName: String { get }
}
