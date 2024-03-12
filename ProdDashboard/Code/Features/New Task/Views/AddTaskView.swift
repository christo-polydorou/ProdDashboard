//  AddTaskView.swift
//  ProdDashboard

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    let dataController = DataController.shared
    
    @State private var hasTime = false // Determines if time selector/recommendation is displayed
    @State private var inputName = "" // Stores user inputted name
    @State private var inputTag = "" // Stores user inputted tag
    @State private var suggestedName = "" // Stores NLP suggested name
    @State private var suggestedTag = "" // Stores NLP suggested tag
    @State private var startDate = Date() // Stores task start time/date
    @State private var endDate = Date() // Stores task end time
    @State private var recStart = Date() // Stores ML recommended start
    @State private var pred = 0.0 // Stores ML prediction
    @State private var gottenRec = false // Keeps track of if a recommendation has been given
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task name", text: $inputName) // Task name input field
                    TextField("Tag", text: $inputTag) // Task tag input field
                    DatePicker("Select a date", selection: $startDate, displayedComponents: .date).datePickerStyle(DefaultDatePickerStyle())
                    Toggle(isOn: $hasTime) { // Toggleable button for if a task has a time
                        Text("Add Time")
                    }
                    if hasTime { // Displays time selectors and recommendation buttons
                        Section {
                            VStack {
                                DatePicker("Start", selection: $startDate, displayedComponents: .hourAndMinute) // Start time picker
                                DatePicker("End", selection: $endDate, displayedComponents: .hourAndMinute) // End time picker
                                Button() {
                                    let result = getRecommendation(name: inputName, tag: inputTag, startDate: startDate) // Calls model functions to get a tuple of tuples of form ((NLP suggested name, NLP suggested tag), (ML predicted duration, ML recommended start time))
                                    suggestedName = result.0.0
                                    suggestedTag = result.0.1
                                    pred = result.1.0
                                    recStart = result.1.1
                                    gottenRec = true
                                } label: {
                                    Text("Get Recommendation").padding()
                                }.buttonStyle(BorderlessButtonStyle()).background(Color.green).foregroundColor(.white).cornerRadius(8).padding().frame(maxWidth: .infinity)
                        }
                            if gottenRec { // Displays recommendation
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
                                Button() { // Fills input fields with recommendation
                                    if let combinedDate = combineDateWithTime(date: startDate, time: recStart) {
                                                                            recStart = combinedDate
                                    }
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
                        Button() { // Adds user inputted task into the database
                            let task = CDTask(name: inputName, startDate: startDate, duration: pred, tag: inputTag, context: context)
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

