//
//  NewTaskButton.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct NewTaskButton: ViewModifier {
    
    var color: Color = Color(red: 0.02, green: 0.47, blue: 0.34)
    var dataSource: DataSource
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, design: .default))
            .frame(maxWidth: 100, maxHeight: 40)
            .foregroundColor(Color.white)
            .background(dataSource.selectedTheme.buttonColor)
//            .cornerRadius(5).shadow(radius: 3, y: 5)
            .cornerRadius(10)

    }
}
