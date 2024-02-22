//
//  SettingsButton.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct SettingsButton: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Image(systemName: "gear")
                .imageScale(.large)
            content
        }
    }
}
