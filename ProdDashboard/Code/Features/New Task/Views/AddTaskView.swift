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
    
    @State private var hasTime = false
    @State private var inputName = ""
    @State private var inputTag = ""
    @State private var suggestedName = ""
    @State private var suggestedTag = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var recStart = Date()
    @State private var pred = 0.0
    @State private var gottenRec = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task name", text: $inputName)
                    TextField("Tag", text: $inputTag)
                    DatePicker("Select a date", selection: $startDate, displayedComponents: .date).datePickerStyle(DefaultDatePickerStyle())
                    Toggle(isOn: $hasTime) {
                        Text("Add Time")
                    }
                    if hasTime {
                        Section {
                            VStack {
                                DatePicker("Start", selection: $startDate, displayedComponents: .hourAndMinute)
                                DatePicker("End", selection: $endDate, displayedComponents: .hourAndMinute)
                                Button() {
                                    let result = getRecommendation(name: inputName, tag: inputTag, startDate: startDate)
                                    suggestedName = result.0.0
                                    suggestedTag = result.0.1
                                    pred = result.1.0
                                    recStart = result.1.1
                                    gottenRec = true
                                } label: {
                                    Text("Get Recommendation").padding()
                                }.buttonStyle(BorderlessButtonStyle()).background(Color.green).foregroundColor(.white).cornerRadius(8).padding().frame(maxWidth: .infinity)
                        }
                            if gottenRec {
                                    HStack {
                                        Text("Recommended Duration: ")
                                        if pred <= 0 {
                                            Text("No recommendation available")
                                        } else {
                                            Text("\(Int(pred)) minutes")
                                        }
                                    }
                                    HStack {
                                        Text("Recommended Start Time: ")
                                        if pred <= 0 {
                                            Text("No recommendation available")
                                        } else {
                                            Text(convertDateToTimeString(date: recStart))
                                        }
                                    }
                                Button() {
                                    startDate = recStart
                                    endDate = startDate.addingTimeInterval(60 * pred)
                                } label: {
                                    Text("Use Recommended Time").padding()
                                }.buttonStyle(BorderlessButtonStyle()).background(Color.green).foregroundColor(.white).cornerRadius(8).padding().frame(maxWidth: .infinity)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Button() {
                            let task = CDTask(name: suggestedName, startDate: Date(), context: context)
                            DataController.shared.save()
                            dismiss()
                        } label: {
                            Text("Add Task").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }.buttonStyle(BorderlessButtonStyle()).foregroundColor(.black).padding().background(Color.green).cornerRadius(8).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                }
            }.background(Color(hex: 0xF9E7C4)).navigationBarTitle("Add New Task")
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
