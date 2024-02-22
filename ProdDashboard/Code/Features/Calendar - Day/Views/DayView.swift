//
//  DayView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 2/7/24.
//

import SwiftUI

struct DayView: View {
    var count: Int
    var startingSpaces: Int
    var daysInMonth: Int
    var daysInPrevMonth: Int
    var sendDate: String
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var dataSource: DataSource
    //@Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<CDTask>

    @State private var showingAddView = false
    @State private var editMode: EditMode = .inactive
    @State private var showingSettings = false
    @State private var showingMonthCal = false
    @State private var currDate = Date()
    
    @State private var addTask = false
    
    private var currentDateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: Date())
        }
    
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
//                Text(sendDate).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 25).padding(.bottom, 25).fontWeight(.light) // Date
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
                AddTaskView(selectedDate: $currDate)
            }
        }
        .presentationDetents([.fraction(0.9)])
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    var body: some View {
//        
//       // let todaysDate = monthStruct().day
//        
//        
//        NavigationView {
//            //Text("hello")
//            VStack(alignment: .leading) {
//                
//                Text(monthStruct().day())
//                    .font(.largeTitle) // Make the title larger
//                    .padding(.top, -50) // Adjust top padding as needed
//                    .padding(.leading, 20)
//                    .padding(.horizontal, 150)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                Text(sendDate) // Display the current date
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                    .padding(.top, -25) // Adjust top padding as needed
//                    .padding(.horizontal, 150)
//                    .padding(.leading, 20)
//                
//                Section {
//                    List {
//                        ForEach(filteredTasks, id: \.self) { task in
//                            NavigationLink(destination: EditTaskView(task: task)) {
//                                HStack {
//                                    VStack(alignment: .leading, spacing: 6) {
//                                        Text(task.name!)
//                                            .bold()
////                                        Text(convertDateToTimeString(date: task.date!))
//                                    }
//                                    Spacer()
//                                }
//                            }
//                        }
//                        .onDelete(perform: deleteTask)
//                    }
//                    .listStyle(DefaultListStyle()) // Use PlainListStyle for a more compact appearance
//                    .background(Color.white)
//                    .cornerRadius(10) // Add corner radius for a container-like appearance
//                    .padding(.bottom, 10)
//                }
//                
////                HStack(alignment: .bottom) {
////                   // Text("Nav Bar: ").padding(10).bold()
////                    Spacer().frame(width: 135, height: 0)
////                    // NavigationLink to navigate to SettingsView
////                    NavigationLink(destination: SettingsView(), isActive: $showingSettings) {
////                            EmptyView()
////                        }
////                        .hidden()
////                        Button {
////                            showingSettings.toggle()
////                            
////                        } label: {
////                            Image(systemName: "gear")
////                            .resizable()
////                            .aspectRatio(contentMode: .fit)
////                            .frame(width: 35, height: 35)
////                            .foregroundColor(.black)
////                        }
////                    
////                    
////                    Spacer().frame(width: 20, height: 0)
////                    
////                    NavigationLink(destination: DateScrollerView(), isActive: $showingMonthCal) {
////                        EmptyView()
////                    }
////                    .hidden()
////                    Button {
////                        showingMonthCal.toggle()
////                        
////                        
////                        
////                    } label: {
////                        Image(systemName: "calendar")
////                        .resizable()
////                        .aspectRatio(contentMode: .fit)
////                        .frame(width: 35, height: 35)
////                        .foregroundColor(.black)
////                    }
////                    
////                    Spacer().frame(width: 20, height: 0)
////                    
////                }
//            }
//            .background(Color(hex: 0xF9E7C4))
////            .toolbar {
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    Button {
////                        showingAddView.toggle()
////                        editMode = .inactive
////                    }
////                label: {
////                        Image("AddTask")
////                            .resizable()
////                            .aspectRatio(contentMode: .fit)
////                            .frame(width: 100, height: 100) // Adjust the size as needed
////                    }
////                }
////                //                ToolbarItem(placement: .navigationBarLeading) {
////                //                    EditButton()
////                //                }
////            }
////            .sheet(isPresented: $showingAddView) {
////                AddFoodView()
////            }
//        }
//        
////        NavigationView {
////            HStack () {
////                Text("Content")
////                    .toolbar {
////                        Button("Add 1") {}
////                        Button("Add 2") {}
////                        Button("Add 3") {}
////                    }
////            }
////        }
////
////        HStack () {
////            Text("NavBar")
////                .background(Color(hex: 0xF9E7C4))
////
////                .environment(\.editMode, $editMode)
////                .navigationViewStyle(.stack)
////        }
//    }
////     Deletes food at the current offset
//    private func deleteTask(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { task[$0] }
//            .forEach(context.delete)
//            
//            // Saves to our database
//            DataController().save()
//        }
//    }
//    
//    func currentDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM dd, yyyy" // Customize the date format as needed
//        return dateFormatter.string(from: Date())
//    }
//    
//    func convertDateToTimeString(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        return formatter.string(from: date)
//    }
//    
//    func monthStruct() -> MonthStruct {
//        let start = startingSpaces == 0 ? startingSpaces + 7 :startingSpaces
//        if (count <= start) {
//            let day = daysInPrevMonth + count - start
//            return MonthStruct(monthType: MonthType.previous, dayInt: day)
//        } else if (count - start > daysInMonth) {
//            let day = count - start - daysInMonth
//            return MonthStruct(monthType: MonthType.next, dayInt: day)
//        }
//        
//        let day = count - start
//        return MonthStruct(monthType: MonthType.current, dayInt: day)
//    }
//    
//
//    
//    
//    
////    private var filteredTasks: [Task] {
////            task.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: Date()) }
////        }
//    
//    private var filteredTasks: [Task] {
//        let currentDayString = monthStruct().day()
//        let currentDayDate = Calendar.current.date(bySetting: .day, value: Int(currentDayString)!, of: Date())!
//        
//        let sendDateComponents = sendDate.components(separatedBy: " ")
//        let sendDateMonth = sendDateComponents[0]
//        let sendDateYear = sendDateComponents[1]
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "LLL yyyy"
//        let sendDateDate = dateFormatter.date(from: "\(sendDateMonth) \(sendDateYear)")!
//        
//        return task.filter { task in
//            let taskDate = Calendar.current.startOfDay(for: task.date ?? Date())
//            let sendDateDay = Calendar.current.startOfDay(for: sendDateDate)
//            
//            return Calendar.current.isDate(taskDate, inSameDayAs: currentDayDate) ||
//                   Calendar.current.isDate(taskDate, inSameDayAs: sendDateDay)
//        }
//    }
//    
//    
    
    
}



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
//            List(filteredTasks) { task in
////                NavigationLink(destination: EditTaskView(task: task)) {
//                    if !(task.completed) {
//                        VStack {
//                            HStack {
//                                Image(systemName: task.completed ? "largecircle.fill.circle" : "circle")
//                                    .onTapGesture {
//                                        task.completed.toggle()
//                                        DataController.shared.save()
//                                    }
//                                Text(task.name).bold().frame(width: 175, height: 15, alignment: .leading)
//                            }
//                            HStack {
//                                Image(systemName: "calendar.badge.clock")
//                                    .font(.system(size: 20, weight: .light))
//                                Text("insert start date")
//                            }.frame(width: 175, height: 15, alignment: .leading)
//
//                        }
//
//                    }
////                }
//            }.scrollContentBackground(.hidden)
            
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
            
            
            
            
//            .gesture(
//                LongPressGesture(minimumDuration: 1.0)
//                    .onEnded { _ in
//                        // Perform the action when long press ends
//                        // You can show an action sheet or navigate to a delete view here
//                        // For simplicity, let's assume you want to delete the task directly
//                        CDTask.delete(task: task)                    }
//            )
            
                
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
    
//    private var filteredTasks: [CDTask] {
//        let currentDayString = monthStruct().day()
//        let currentDayDate = Calendar.current.date(bySetting: .day, value: Int(currentDayString)!, of: Date())!
//        
//        let sendDateComponents = sendDate.components(separatedBy: " ")
//        let sendDateMonth = sendDateComponents[0]
//        let sendDateYear = sendDateComponents[1]
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "LLL yyyy"
//        let sendDateDate = dateFormatter.date(from: "\(sendDateMonth) \(sendDateYear)")!
//        
//        return tasks.filter { task in
//            let taskDate = Calendar.current.startOfDay(for: task.date ?? Date())
//            let sendDateDay = Calendar.current.startOfDay(for: sendDateDate)
//             
//            return Calendar.current.isDate(taskDate, inSameDayAs: currentDayDate) ||
//                   Calendar.current.isDate(taskDate, inSameDayAs: sendDateDay)
//        }
//    }
    
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

