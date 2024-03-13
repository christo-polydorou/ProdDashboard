//
//  DayView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 2/7/24.
//

import SwiftUI

// shows lists of uncompleted and completed tasks for a given day
struct DayView: View {
    // variables sent view to determine the day
    var count: Int
    var startingSpaces: Int
    var daysInMonth: Int
    var daysInPrevMonth: Int
    var sendDate: String
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var dataSource: DataSource
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<CDTask>

    @State private var showingAddView = false
    @State private var editMode: EditMode = .inactive
    @State private var showingSettings = false
    @State private var showingMonthCal = false
    @State private var currDate = Date()
    
    @State private var addTask = false

    // returns string version of current date
    private var currentDateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: Date())
        }

    //defines the components of the view
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(dataSource.selectedTheme.backgroundColor).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                HStack {
                    Text(monthStruct().day()).font(Font.custom("Montserrat", size: 50)) // Title
                        .padding(.leading, 15)
                        .padding(.top, 15)
                    Spacer()
                    Button("+ Add Task") {
                        addTask.toggle()
                    }.modifier(NewTaskButton(dataSource: dataSource))
                }.padding(.leading).padding(.trailing)
                let date = Date().formatted(date: .abbreviated, time: .omitted)
//                // displays a list of uncompleted and completed tasks on the day determined by the passed variables
                UncompletedSection2(count: count,
                                    startingSpaces: startingSpaces,
                                    daysInMonth: daysInMonth,
                                    daysInPrevMonth: daysInPrevMonth, sendDate: sendDate)
                CompletedSection2(count: count,
                                  startingSpaces: startingSpaces,
                                  daysInMonth: daysInMonth,
                                  daysInPrevMonth: daysInPrevMonth, sendDate: sendDate)
//                NavigationMenu().offset(y: 20)
            }
            .sheet(isPresented: $addTask) {
                AddTaskView()
            }
        }
        .presentationDetents([.fraction(0.9)])
        
    }
    // returns string version of current date
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Customize the date format as needed
        return dateFormatter.string(from: Date())
    }
    // returns string of date in HH:mm:ss form
    func convertDateToTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }

    // creates a structure that provides information to the MonthView about the current day and the range
    // of tha month/which month it is
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 :startingSpaces
        if (count <= start) {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.previous, dayInt: day)
        } else if (count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.current, dayInt: day)
    }
    
   
    
}


// displays a list of all uncompleted tasks
struct UncompletedSection2: View {
    var count: Int
    var startingSpaces: Int
    var daysInMonth: Int
    var daysInPrevMonth: Int
    var sendDate: String

    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    var body: some View {
        VStack {
            Text("To-Do").offset(x: -135, y: 12).font(.title).fontWeight(.light).underline()

            List {
                ForEach(filteredTasks) { task in
                    if !(task.completed) {
                        VStack {
                            HStack {
                                Image(systemName: task.completed ? "largecircle.fill.circle" : "circle")
                                    .onTapGesture {
                                        task.completed.toggle()
                                        DataController.shared.save()
                                    }
                                Text(task.name).bold().frame(width: 175, height: 15, alignment: .leading)
                            }
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 20, weight: .light))
                                Text("insert start date")
                            }.frame(width: 175, height: 15, alignment: .leading)
                                
                        }
                    }
                }.onDelete(perform: deleteTask)
            }.scrollContentBackground(.hidden)
                 
        }
        
        
    }
    
    // deletes a task from the coreData list of tasks
    private func deleteTask(offsets: IndexSet) {
            withAnimation {
                offsets.map { tasks[$0] }
                    .forEach(context.delete)
                
                DataController.shared.save()
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
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 :startingSpaces
        if (count <= start) {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.previous, dayInt: day)
        } else if (count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.current, dayInt: day)
    }
    

    // method that accesses that list of task objects stored in core data, filters them and
    // returns a new list of tasks on the day passed to dayView
    private var filteredTasks: [CDTask] {
        let currentDayString = monthStruct().day()
        let currentDayDate = Calendar.current.date(bySetting: .day, value: Int(currentDayString)!, of: Date())!

        return tasks.filter { task in
            guard let taskDate = task.startDate_ else { return false }
            let taskDayDate = Calendar.current.startOfDay(for: taskDate)
            return Calendar.current.isDate(taskDayDate, inSameDayAs: currentDayDate)
        }
    }
}



// displays a list of all completed tasks
struct CompletedSection2: View {
    var count: Int
    var startingSpaces: Int
    var daysInMonth: Int
    var daysInPrevMonth: Int
    var sendDate: String
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    var body: some View {
        VStack {
            Text("Done").offset(x: -135, y: 12).font(.title).fontWeight(.light).underline()
//            List(filteredTasks) { task in
//                if (task.completed) {
//                    VStack {
//                        HStack {
//                            Image(systemName: task.completed ? "largecircle.fill.circle" : "circle")
//                                .onTapGesture {
//                                    task.completed.toggle()
//                                    DataController.shared.save()
//                                }
//                            Text(task.name).bold().frame(width: 175, height: 15, alignment: .leading)
//                        }
//                        HStack {
//                            Image(systemName: "calendar.badge.clock")
//                                .font(.system(size: 20, weight: .light))
//                            Text("insert start date")
//                        }.frame(width: 175, height: 15, alignment: .leading)
//                    }
//                
//                }
//            }.scrollContentBackground(.hidden)
            List {
                ForEach(filteredTasks) { task in
                    if (task.completed) {
                        VStack {
                            HStack {
                                Image(systemName: task.completed ? "largecircle.fill.circle" : "circle")
                                    .onTapGesture {
                                        task.completed.toggle()
                                        DataController.shared.save()
                                    }
                                Text(task.name).bold().frame(width: 175, height: 15, alignment: .leading)
                            }
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 20, weight: .light))
                                Text("insert start date")
                            }.frame(width: 175, height: 15, alignment: .leading)
                                
                        }
                    }
                }.onDelete(perform: deleteTask)
            }.scrollContentBackground(.hidden)
                
        }
        
        
    }
    
    private func deleteTask(offsets: IndexSet) {
            withAnimation {
                offsets.map { tasks[$0] }
                    .forEach(context.delete)
                
                DataController.shared.save()
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
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 :startingSpaces
        if (count <= start) {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.previous, dayInt: day)
        } else if (count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.current, dayInt: day)
    }
    
    private var filteredTasks: [CDTask] {
        let currentDayString = monthStruct().day()
        let currentDayDate = Calendar.current.date(bySetting: .day, value: Int(currentDayString)!, of: Date())!

        return tasks.filter { task in
            guard let taskDate = task.startDate_ else { return false }
            let taskDayDate = Calendar.current.startOfDay(for: taskDate)
            return Calendar.current.isDate(taskDayDate, inSameDayAs: currentDayDate)
        }
    }
    
}











struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, sendDate: "")
            .environmentObject(DataSource())
    }
}

