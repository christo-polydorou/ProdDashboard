//
//  AddTaskView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import Foundation

import SwiftUI

struct AddFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var calories: Double = 0
    
    var body: some View {
            Form {
                Section() {
                    TextField("Task name", text: $name)
                    
//                    VStack {
//                        Text("Calories: \(Int(calories))")
//                        Slider(value: $calories, in: 0...1000, step: 10)
//                    }
//                    .padding()
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            DataController().addTask(name: name, context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
                }
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
