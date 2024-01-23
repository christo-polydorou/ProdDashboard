//
//  WeekButton.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct WeekButton: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Image(systemName: "note")
            content
        }
    }
}
