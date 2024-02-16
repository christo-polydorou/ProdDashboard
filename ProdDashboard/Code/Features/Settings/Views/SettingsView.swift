import SwiftUI

struct SettingsView: View {
    @AppStorage("machineLearningEnabled") private var machineLearningEnabled = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var isShowingNewSchedule = false
    @State private var selectedDate = Date()

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
                Spacer()
                Spacer()
                
                
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
                        //Spacer()
                        Button("Add Schedule") {
                            isShowingNewSchedule = true
                        }
                        .frame(maxWidth: .infinity) // Center the button horizontally
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .sheet(isPresented: $isShowingNewSchedule) {
                            NewScheduleView(selectedDate: $selectedDate)
                        }
                    }
                    //Spacer()
                }
                .padding(.top, 30)
                
                VStack {

                    Button("Edit Schedule") {
                        isShowingNewSchedule = true
                    }
                    .frame(maxWidth: .infinity) // Center the button horizontally
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                    .sheet(isPresented: $isShowingNewSchedule) {
                        NewScheduleView(selectedDate: $selectedDate)
                    }
                    Spacer()
                    
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct NewScheduleView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            DatePicker("Select Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            Button("Submit New Schedule") {
                // Handle submitting new schedule
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


