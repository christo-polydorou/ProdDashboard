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
    @State private var selectedDates: Set<DateComponents> = []
    
    var body: some View {
            Form {
                Section() {
                    TextField("Task name", text: $name)

                    
                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())

                    
                    
                    VStack {
                        MultiDatePicker("Select dates", selection: $selectedDates)
                    }
                    
                    let convertedDates = selectedDates.compactMap { dateComponents -> Date? in
                        let calendar = Calendar.current
                        return calendar.date(from: dateComponents)
                    }

                    HStack {
                        Spacer()
                        Button("Submit") {
                            DataController().addTask(name: name, date: selectedDate, dates: convertedDates, context: managedObjContext)
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
