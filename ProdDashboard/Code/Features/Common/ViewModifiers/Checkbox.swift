//
//  Checkbox.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/18/24.
//

import SwiftUI

struct Checkbox: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: {configuration.isOn.toggle()}, label: {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
            })
            configuration.label
        }
    }
}
