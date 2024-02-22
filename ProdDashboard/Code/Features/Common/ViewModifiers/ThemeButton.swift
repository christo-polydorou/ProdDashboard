//
//  ThemeButton.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/22/24.
//

import SwiftUI

struct ThemeButton: ViewModifier {
    
    var color: Color = Color(red: 0.02, green: 0.47, blue: 0.34)
    var dataSource: DataSource
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(BorderedButtonStyle())
            .foregroundColor(.black) // Set text color
            .cornerRadius(8) // Set corner radius for rounded corners
            .padding(6) // Add padding for better spacing

    }
}
