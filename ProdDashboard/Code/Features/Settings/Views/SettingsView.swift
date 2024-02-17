import SwiftUI

// Model to represent a schedule entry
struct ScheduleEntry {
    var startTime: Date
    var endTime: Date
}

struct SettingsView: View {
    @AppStorage("machineLearningEnabled") private var machineLearningEnabled = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var isShowingNewSchedule = false
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
                .padding(.top)
                //Spacer()
                //Spacer()
                
                
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
                
                VStack {
                    Section(header: Text("Schedule Settings")) {
                        Button("Add Schedule") {
                            isShowingNewSchedule = true
                        }
                        .frame(maxWidth: .infinity) // Center the button horizontally
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .sheet(isPresented: $isShowingNewSchedule) {
                            NewScheduleView(schedules: $schedules)
                        }
                    }
                }
                .padding(.top, 450)
                
                // Your existing code for Edit Schedule button and Spacer
            }
        }
    }
}

struct NewScheduleView: View {
    @Binding var schedules: [[ScheduleEntry]] // Binding to update the parent array
    @State private var startTime = Date()
    @State private var endTime = Date()

    var body: some View {
        VStack {
            // Date pickers for start and end times
            DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            // Button to add the schedule entry
            Button("Add Schedule") {
                let newEntry = ScheduleEntry(startTime: startTime, endTime: endTime)
                schedules.append([newEntry])
                // Optionally, you can add validation or handle duplicates here
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
