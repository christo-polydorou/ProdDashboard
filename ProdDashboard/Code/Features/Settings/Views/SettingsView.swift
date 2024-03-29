import SwiftUI

// Model to represent a schedule entry with stored start date, end date, and weekday
struct ScheduleEntry: Hashable {
    var startTime: Date
    var endTime: Date
    var weekday: Int // 1 for Sunday, 2 for Monday, ..., 7 for Saturday
}

// SettingsView struct which contains the toggle for machine learning suggestions, buttons to add to and edit stored schedules, and selection between themes handled by the dataSource
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
            Rectangle().foregroundColor(.clear).background(dataSource.selectedTheme.backgroundColor).edgesIgnoringSafeArea(.all)
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
                    }
                }
                .padding(.horizontal)

                Section(header: Text("Schedule Settings")
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                ) {
                    HStack(spacing: 20) {
                        //Brings up new schedule sheet to add new recurring events which asks for start time, end time, and weekdays
                        Button("Add Schedule") {
                            isShowingNewSchedule = true
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(dataSource.selectedTheme.buttonColor)
                        .cornerRadius(10)
                        .sheet(isPresented: $isShowingNewSchedule) {
                            NewScheduleView(schedules: $schedules)
                        }
                        
                        // Brings up editSchedule sheet which shows all current added schedules and allows for removal
                        Button("Edit Schedule") {
                            isShowingEditSchedule = true
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(dataSource.selectedTheme.buttonColor)
                        .cornerRadius(10)
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
                    HStack {
                        ForEach(0..<ThemeManager.themes.count, id: \.self) { theme in
                            Button(action: {
                                dataSource.selectedThemeAS = theme
                            }) {
                                VStack {
                                    Text(ThemeManager.themes[theme].themeName)
                                        .foregroundColor(ThemeManager.themes[theme].buttonColor)
                                        .frame(maxWidth: dataSource.selectedThemeAS == theme ? 150 : 130, minHeight: dataSource.selectedThemeAS == theme ? 80 : 70)
                                        .cornerRadius(10)
                                        .fontWeight(.bold)
                                }
                            }
                            .background(.white)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(dataSource.selectedThemeAS == theme ? dataSource.selectedTheme.buttonColor : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            .padding(.top, 10)
            .padding(.bottom, 200)
        }
    }
}

//New Schedule sheet which takes in 3 variables, Date startTime, Date endTime, and Array selectedWeekdays
struct NewScheduleView: View {
    @Binding var schedules: [ScheduleEntry] // Binding to update the parent array
    @EnvironmentObject var dataSource: DataSource // Access to the selected theme
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedWeekdays: Set<Int> = [] // Set to store selected weekdays

    var body: some View {
        ZStack {
            Rectangle() // Background rectangle to cover the entire view
                .fill(dataSource.selectedTheme.backgroundColor)
                .ignoresSafeArea()
            
            VStack {
                Text("New Schedule")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                // Date pickers for start and end times
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                Text("Scheduled Days:")
                    .font(.headline)
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
                                .padding(10)
                                .foregroundColor(selectedWeekdays.contains(weekday) ? .white : .black)
                                .background(selectedWeekdays.contains(weekday) ? dataSource.selectedTheme.buttonColor : dataSource.selectedTheme.backgroundColor.opacity(0.5))
                                .cornerRadius(8)
                        }
                    }
                }

                // Button to add the schedule entry
                Button("Add Schedule") {
                    for weekday in selectedWeekdays {
                        let newEntry = ScheduleEntry(startTime: startTime, endTime: endTime, weekday: weekday)
                        schedules.append(newEntry)
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(dataSource.selectedTheme.buttonColor)
                .cornerRadius(8)
                .padding()
            }
        }
        .cornerRadius(10)
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

// EditSchedule sheet which shows all current schedules and allows of an event from stored schedules
struct EditScheduleView: View {
    @Binding var schedules: [ScheduleEntry] // Binding to update the parent array
    @EnvironmentObject var dataSource: DataSource
    var body: some View {
        ZStack {
            Rectangle() // Background rectangle to cover the entire view
                .fill(dataSource.selectedTheme.backgroundColor)
                .ignoresSafeArea()
            VStack {
                Text("Edit Schedule")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
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
                    
                    .padding(.bottom, 10)
                }
            }
        }
        }
    }
    
// Helper function for storing weekday of a stored schedule
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

// Preview for SettingsView
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DataSource())
    }
}
