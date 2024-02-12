//
//  EditTaskView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import Foundation
import SwiftUI

//struct MultiDatePickerWrapper: View {
//    @Binding var selectedDates: Set<Date>
//    
//    var body: some View {
//        MultiDatePicker(selection: Binding(
//            get: {
//                Set(selectedDates.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) })
//            },
//            set: { dateComponentsSet in
//                selectedDates = Set(dateComponentsSet.compactMap {
//                    Calendar.current.date(from: $0)
//                })
//            }
//        ), in: ...Date())
//        .datePickerStyle(.automatic)
//    }
//}

struct EditTaskView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var task: FetchedResults<Task>.Element
    
    @State private var name = ""
    @State private var currentDates: Set<DateComponents> = []
    @State private var selectedDate = Date()
    
    var body: some View {
        Form {
            Section() {
                TextField("\(task.name1)", text: $name)
                    .onAppear {
                        name = task.name1
                    }
                
                VStack {

                    DatePicker("Select a date", selection: Binding(get: {
                        task.date1 ?? Date()
                    }, set: { currDate in
                        selectedDate = currDate
                    }), displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                }
                
//                VStack {
//                    MultiDatePicker("Select dates", selection: Binding(get: {
//                        return getDates(dates: task.dates!)
//                    }, set: { newDates in
//                        // Update the original array with the new dates
//                    }))
//                }

                
                HStack {
                    Spacer()
                    Button("Submit") {
                        DataController().editTask(task: task, name: name, date: selectedDate, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func getDates(dates: [Date]) -> Set<DateComponents> {
        for date in dates {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            currentDates.insert(dateComponents)
        }
        return currentDates
    }
}
