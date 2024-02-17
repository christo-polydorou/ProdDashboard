import SwiftUI

// Model to represent a schedule entry
struct ScheduleEntry: Hashable {
    var startTime: Date
    var endTime: Date
    var isRecurring: Bool
}

struct SettingsView: View {
    @AppStorage("machineLearningEnabled") private var machineLearningEnabled = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var isShowingNewSchedule = false
    @State private var isShowingEditSchedule = false
    @State private var selectedDate = Date()
    @State private var schedules: [[ScheduleEntry]] = [] // Array to store schedule entries

    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(Color(red: 1, green: 0.95, blue: 0.91)).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                Text("Settings").font(Font.custom("Montserrat", size: 50)).padding(.leading).padding(.trailing)
                
                Section(header: Text("General Settings")) {
                    Toggle("Machine Learning Suggestions", isOn: $machineLearningEnabled)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Section{
                    Toggle("Dark Mode", isOn: Binding(
                        get: { colorScheme == .dark },
                        set: { _ in
                            if colorScheme == .dark {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                            } else {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                            }
                        }
                    ))
                }
                .padding(.horizontal)
                //.padding(.top, 50)
                
                VStack {
                    Section(header: Text("Schedule Settings")) {
                        Button("Add Schedule") {
                            isShowingNewSchedule = true
                        }
                        .frame(maxWidth: .infinity) // Center the button horizontally
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.02, green: 0.47, blue: 0.34))
                        .cornerRadius(8)
                        .sheet(isPresented: $isShowingNewSchedule) {
                            NewScheduleView(schedules: $schedules)
                        }
                        
                        Button("Edit Schedule") {
                            isShowingEditSchedule = true
                        }
                        .frame(maxWidth: .infinity) // Center the button horizontally
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.02, green: 0.47, blue: 0.34))
                        .cornerRadius(8)
                        .sheet(isPresented: $isShowingEditSchedule) {
                            EditScheduleView(schedules: $schedules)
                        }
                    }
                }
                .padding(.top, 40)
                
                // Your existing code for Edit Schedule button and Spacer
            }
            .padding(.top, -350)
        }
    }
}

struct NewScheduleView: View {
    @Binding var schedules: [[ScheduleEntry]] // Binding to update the parent array
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var isRecurring = false // Added state for recurring checkbox

    var body: some View {
        VStack {
            // Date pickers for start and end times
            DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            // Checkbox for recurrence
            Toggle("Recurring", isOn: $isRecurring)
                .padding()
            
            // Button to add the schedule entry
            Button("Add Schedule") {
                let newEntry = ScheduleEntry(startTime: startTime, endTime: endTime, isRecurring: isRecurring)
                schedules.append([newEntry])
                // Optionally, you can add validation or handle duplicates here
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 0.02, green: 0.47, blue: 0.34))
            .cornerRadius(8)
            .padding()
        }
    }
}

struct EditScheduleView: View {
    @Binding var schedules: [[ScheduleEntry]] // Binding to update the parent array
    
    var body: some View {
        NavigationView {
            List {
                ForEach(schedules.indices, id: \.self) { index in
                    Section(header: Text("Schedule \(index + 1)")) {
                        ForEach(schedules[index], id: \.self) { entry in
                            VStack {
                                Text("Start Time: \(entry.startTime, formatter: dateFormatter)")
                                Text("End Time: \(entry.endTime, formatter: dateFormatter)")
                                Text("Recurring: \(entry.isRecurring ? "Yes" : "No")")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Schedule")
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the sheet
                schedules = [] // Clear schedules after editing
            })
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
