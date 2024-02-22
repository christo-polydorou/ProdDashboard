//
//  StatsButton.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/13/24.
//

import Foundation

import SwiftUI

struct StatsButton: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Image(systemName: "chart.bar")
                .imageScale(.large)
            content
        }
    }
}
