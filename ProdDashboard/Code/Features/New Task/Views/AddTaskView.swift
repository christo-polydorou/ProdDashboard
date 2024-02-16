//
//  AddTaskView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    let dataController = DataController.shared
    
    @State private var name = ""
    @State private var selectedDate = Date()
    @State private var selectedDates: Set<DateComponents> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section {
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
                        Button("Add Task") {
//                            DataController().addTask(name: name, date: selectedDate, dates: convertedDates, context: managedObjContext)
//                            dismiss()
                            let task = CDTask(name: name, startDate: selectedDate, context: context)
                            DataController.shared.save()
                            dismiss()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        Spacer()
                    }
                    
                }
            }
            .background(Color(hex: 0xF9E7C4)) // Set background color for the entire view
            .navigationBarTitle("New Task") // Set navigation bar title
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
