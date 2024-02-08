//
//  ContentView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 12/19/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dateHolder: DateHolder
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var task: FetchedResults<Task>

    @State private var showingAddView = false
    @State private var editMode: EditMode = .inactive
    @State private var showingSettings = false
    @State private var showingMonthCal = false
    
    private var currentDateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: Date())
        }
    
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("Today")
                    .font(.largeTitle) // Make the title larger
                    .padding(.top, -50) // Adjust top padding as needed
                    .padding(.leading, 20)
                
                Text(currentDate()) // Display the current date
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.top, -25) // Adjust top padding as needed
                    .padding(.leading, 20)
                
                Section {
                    List {
                        ForEach(filteredTasks, id: \.self) { task in
                            NavigationLink(destination: EditTaskView(task: task)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(task.name!)
                                            .bold()
//                                        Text(convertDateToTimeString(date: task.date!))
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .listStyle(DefaultListStyle()) // Use PlainListStyle for a more compact appearance
                    .background(Color.white)
                    .cornerRadius(10) // Add corner radius for a container-like appearance
                    .padding(.bottom, 10)
                }
                
                HStack(alignment: .bottom) {
                   // Text("Nav Bar: ").padding(10).bold()
                    Spacer().frame(width: 135, height: 0)
                    // NavigationLink to navigate to SettingsView
                    NavigationLink(destination: SettingsView(), isActive: $showingSettings) {
                            EmptyView()
                        }
                        .hidden()
                        Button {
                            showingSettings.toggle()
                            
                        } label: {
                            Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.black)
                        }
                    
                    
                    Spacer().frame(width: 20, height: 0)
                    
                    NavigationLink(destination: DateScrollerView(), isActive: $showingMonthCal) {
                        EmptyView()
                    }
                    .hidden()
                    Button {
                        showingMonthCal.toggle()
                        
                        
                        
                    } label: {
                        Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.black)
                    }
                    
                    Spacer().frame(width: 20, height: 0)
                    
                }
            }
            .background(Color(hex: 0xF9E7C4))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                        editMode = .inactive
                    } label: {
                        Image("AddTask")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100) // Adjust the size as needed
                    }
                }
                //                ToolbarItem(placement: .navigationBarLeading) {
                //                    EditButton()
                //                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        
//        NavigationView {
//            HStack () {
//                Text("Content")
//                    .toolbar {
//                        Button("Add 1") {}
//                        Button("Add 2") {}
//                        Button("Add 3") {}
//                    }
//            }
//        }
//        
//        HStack () {
//            Text("NavBar")
//                .background(Color(hex: 0xF9E7C4))
//            
//                .environment(\.editMode, $editMode)
//                .navigationViewStyle(.stack)
//        }
    }
//     Deletes food at the current offset
    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { task[$0] }
            .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
    
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Customize the date format as needed
        return dateFormatter.string(from: Date())
    }
    
    func convertDateToTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    
    var daysOfWeekStack: some View {
        HStack(spacing: 1) {
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
        }
    }

    var calendarGrid: some View {
        
        VStack(spacing: 1) {
            let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
            let prevMonth = CalendarHelper().minusMonth(dateHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
            
            ForEach(0..<6) {
                row in
                HStack(spacing: 1) {
                    ForEach(1..<8) {
                        column in
                        let count = column + (row * 7)
                        
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                    }
                }
            }
        }.frame(maxHeight: .infinity)
    }
    
    
    private var filteredTasks: [Task] {
            task.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: Date()) }
        }
    
    
    
    
    
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}
