import SwiftUI

// Model to represent a schedule entry
struct ScheduleEntry: Hashable {
    var startTime: Date
    var endTime: Date
    var weekday: Int // 1 for Sunday, 2 for Monday, ..., 7 for Saturday
}

struct SettingsView: View {
    @AppStorage("machineLearningEnabled") private var machineLearningEnabled = false
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var dataSource: DataSource
    @State private var isShowingNewSchedule = false
    @State private var isShowingEditSchedule = false
    @State private var selectedDate = Date()
    @State private var schedules: [ScheduleEntry] = [] // Array to store schedule entries

    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(dataSource.selectedTheme.backgroundColor).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                Text("Settings").font(Font.custom("Montserrat", size: 50)).padding(.leading).padding(.trailing)
                    .padding(.bottom, 50)
                
                Section(header: Text("General Settings")
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                ) {
                    VStack {
                        Toggle("Machine Learning Suggestions", isOn: $machineLearningEnabled)
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
                }
                .padding(.horizontal)
//                .padding(.bottom, 20)
//                Spacer()
//                Section(header: Text("Change Appearance")
//                    .font(.title2)
//                    .foregroundColor(.blue)
//                ) {
//                    HStack {
//                        ForEach(0..<ThemeManager.themes.count, id: \.self) { theme in
//                            Button(action: {
//                                dataSource.selectedThemeAS = theme
//                            }) {
//                                Text(ThemeManager.themes[theme].themeName)
//                                    .foregroundColor(.white) // Set text color
//                                    .padding(15) // Add padding for better spacing
//                            }
//                            .buttonStyle(BorderedButtonStyle())
//                            .foregroundColor(.white) // Set text color
//                            .background(ThemeManager.themes[theme].buttonColor
//                                .overlay(
//                                    Circle().stroke(.black, lineWidth: dataSource.selectedThemeAS == theme ? 10 : 0)
//                                )
//                            )
//    //                            .cornerRadius(8) // Set corner radius for rounded corners
//                            .clipShape(Circle())
//
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//                
//                
                
                Section(header: Text("Schedule Settings")
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                ) {
                    HStack {
                        Button("Add Schedule") {
                            isShowingNewSchedule = true
                        }
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
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.02, green: 0.47, blue: 0.34))
                        .cornerRadius(8)
                        .sheet(isPresented: $isShowingEditSchedule) {
                            EditScheduleView(schedules: $schedules)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                Section(header: Text("Appearance")
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                ) {
                    VStack {
                        ForEach(0..<ThemeManager.themes.count, id: \.self) { theme in
                            Button(action: {
                                dataSource.selectedThemeAS = theme
                            }) {
                                Text(ThemeManager.themes[theme].themeName)
                                    .foregroundColor(.white) // Set text color
                                    .padding(15) // Add padding for better spacing
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                            }
//                            .buttonStyle(BorderedButtonStyle())
                            .foregroundColor(.white)
//                            .cornerRadius(30)
                            .background(ThemeManager.themes[theme].buttonColor
                                .overlay(
                                    Circle().stroke(.black, lineWidth: dataSource.selectedThemeAS == theme ? 10 : 0)
                                )
                            )
                            .cornerRadius(30)
                        }
                    }
                }
                .padding(.horizontal)
//                .padding(.top, 20)
                .padding(.bottom, 60)
                
            }
            .padding(.top, 10)
        }
    }
}

//HStack {
//    Button(action: {
//        // Present your sheet here
//    }) {
//        Text("Change Appearance")
//            .foregroundColor(.accentColor)
//    }
//    Button {
//        // Action to perform when the button is tapped
//        // Add your code here
//    } label: {
//        Text("The Outline")
//            .padding()
//            .background {
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(.yellow, lineWidth: 2) // Use Color.buttonGoldColor if it's a custom color
//            }
//    }
//}
//.padding(.bottom, 200)

struct NewScheduleView: View {
    @Binding var schedules: [ScheduleEntry] // Binding to update the parent array
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedWeekdays: Set<Int> = [] // Set to store selected weekdays

    var body: some View {
        VStack {
            // Date pickers for start and end times
            DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            // Buttons for each weekday
            HStack {
                ForEach(1 ..< 8, id: \.self) { weekday in
                    Button(action: {
                        if selectedWeekdays.contains(weekday) {
                            selectedWeekdays.remove(weekday)
                        } else {
                            selectedWeekdays.insert(weekday)
                        }
                    }) {
                        Text(weekdayLabel(for: weekday))
                            .padding()
                            .foregroundColor(selectedWeekdays.contains(weekday) ? .white : .black)
                            .background(selectedWeekdays.contains(weekday) ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            // Button to add the schedule entry
            Button("Add Schedule") {
                for weekday in selectedWeekdays {
                    let newEntry = ScheduleEntry(startTime: startTime, endTime: endTime, weekday: weekday)
                    schedules.append(newEntry)
                }
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
    
    func weekdayLabel(for weekday: Int) -> String {
        switch weekday {
        case 1: return "S"
        case 2: return "M"
        case 3: return "T"
        case 4: return "W"
        case 5: return "T"
        case 6: return "F"
        case 7: return "S"
        default: return ""
        }
    }
}

struct EditScheduleView: View {
    @Binding var schedules: [ScheduleEntry] // Binding to update the parent array
    
    var body: some View {
        NavigationView {
            List {
                ForEach(schedules.indices, id: \.self) { index in
                    Section(header: Text("Schedule \(index + 1)")) {
                        let schedule = schedules[index]
                        VStack {
                            Text("Start Time: \(schedule.startTime, formatter: dateFormatter)")
                            Text("End Time: \(schedule.endTime, formatter: dateFormatter)")
                            Text("Weekday: \(weekdayLabel(for: schedule.weekday))")
                            Button("Remove Schedule") {
                                schedules.remove(at: index)
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Edit Schedule")
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func weekdayLabel(for weekday: Int) -> String {
        switch weekday {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return ""
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DataSource())
    }
}
