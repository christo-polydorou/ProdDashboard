//
//  EditTaskView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import Foundation
import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var task: FetchedResults<Task>.Element
    
    @State private var name = ""
    @State private var dates: Set<DateComponents> = []
    @State private var selectedDate = Date()
    
    
    var body: some View {
        Form {
            Section() {
                TextField("\(task.name!)", text: $name)
                    .onAppear {
                        name = task.name!
                    }
                
                VStack {

                    DatePicker("Select a date", selection: Binding(get: {
                        task.date ?? Date()
                    }, set: { currDate in
                        selectedDate = currDate
                    }), displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                }
                
//                VStack {
//                    
//                    MultiDatePicker("Select dates", selection: $dates
//                    )
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
}
