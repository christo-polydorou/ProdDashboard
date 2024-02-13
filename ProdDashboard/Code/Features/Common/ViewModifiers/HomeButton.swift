//
//  HomeButton.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct HomeButton: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Image(systemName: "house.fill")
                .imageScale(.large)
            content
        }
    }
}
