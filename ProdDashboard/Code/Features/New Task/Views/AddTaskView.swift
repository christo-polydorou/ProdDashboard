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
    @State private var selectedDate = Date()
    @State private var dates: Set<DateComponents> = []
    
    var body: some View {
            Form {
                Section() {
                    TextField("Task name", text: $name)
                    
//                    VStack {
//                        Text("Calories: \(Int(calories))")
//                        Slider(value: $calories, in: 0...1000, step: 10)
//                    }
//                    .padding()
                    
//                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
//                        .datePickerStyle(DefaultDatePickerStyle()) // You can choose a different style if needed
//
//                    
                    
//                    VStack {
//                        
//                        MultiDatePicker("Select dates", selection: $dates
//                        )
//                    }
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            DataController().addTask(name: name, date: selectedDate, context: managedObjContext)
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
