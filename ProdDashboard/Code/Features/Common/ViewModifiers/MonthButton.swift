//
//  MonthButton.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct MonthButton: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Image(systemName: "calendar")
                .imageScale(.large)
            content
        }
    }
}


