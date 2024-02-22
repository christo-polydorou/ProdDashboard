//
//  TaskListScreen.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/11/24.
//

import Foundation
import SwiftUI
import CoreData

struct TaskListScreen: View {
    @EnvironmentObject var dataSource: DataSource
    @Environment(\.managedObjectContext) var context
    @State private var addTask = false
    @State private var currentDate = Date()
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(dataSource.selectedTheme.backgroundColor).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                HStack {
                    Text("Today").font(Font.custom("Montserrat", size: 50)) // Title
                    Spacer()
                    Button("+ Add Task") {
                        addTask.toggle()
                    }.modifier(NewTaskButton(dataSource: dataSource))
                }.padding(.leading).padding(.trailing)
                let date = Date().formatted(date: .abbreviated, time: .omitted)
                Text(date).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 25).padding(.bottom, 25).fontWeight(.light) // Date
                UncompletedSection()
                CompletedSection()
            }
            .sheet(isPresented: $addTask) {
                AddTaskView()
            }
        }
    }
}

struct UncompletedSection: View {

    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dataSource: DataSource
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    let options = ["School", "Work", "CS"]
    @State private var selectedOption = 0

    var body: some View {
        VStack {
            HStack(spacing:10) {
                Text("To-Do")
                    .font(.title)
                    .fontWeight(.light)
                    .underline()
                    .frame(width: 100, alignment: .leading)
                    .padding(.leading, 20)
                
                Picker(selection: $selectedOption, label: Text("Select an option")) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Text(self.options[index]).tag(index)
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .font(.system(size: 14, design: .default))
                .frame(maxWidth: 100, maxHeight: 40)
                .background(.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            .offset(x: -75, y: 12)
            
            
            List {
                ForEach(tasks) { task in
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
                                Text(getHourAndMinute(from: task.startDate))
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
        .onAppear{
            let tasksCount = tasks.count
            Swift.print("Number of tasks: \(tasksCount)")
        }
    }
    private func deleteTask(offsets: IndexSet) {
            withAnimation {
                offsets.map { tasks[$0] }
                    .forEach(context.delete)
                
                DataController.shared.save()
            }
        }
//    private var filteredTasks: [CDTask] {
//            let currentDate = Date()
//            return tasks.filter { task in
//                guard let taskDate = task.startDate_ else { return false } // Ensure task has a date
//                return Calendar.current.isDate(taskDate, inSameDayAs: currentDate)
//            }
//        }
    private var filteredTasks: [CDTask] {
        let currentDate = Date()
        let currentDayStart = Calendar.current.startOfDay(for: currentDate)
        return tasks.filter { task in
            guard let taskDate = task.startDate_ else { return false } // Ensure task has a date
            let taskDayStart = Calendar.current.startOfDay(for: taskDate)
            return taskDayStart == currentDayStart
        }
    }
    
    func getHourAndMinute(from date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        // Extracting individual time components
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
        // Determine AM/PM
        let amPM: String
        if hour >= 12 {
            amPM = "PM"
        } else {
            amPM = "AM"
        }
        
        // Convert to 12-hour format
        var hourIn12HourFormat = hour % 12
        if hourIn12HourFormat == 0 {
            hourIn12HourFormat = 12 // 0 hour is 12 AM in 12-hour format
        }

        // Formatting the time string
        let hourString: String
        if hourIn12HourFormat < 10 {
            hourString = "\(hourIn12HourFormat)"
        } else {
            hourString = String(format: "%02d", hourIn12HourFormat)
        }
        
        let timeString = "\(hourString):\(String(format: "%02d", minute)) \(amPM)"
        
        return timeString
    }
}


struct CompletedSection: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    var body: some View {
        VStack {
            Text("Done").offset(x: -135, y: 12).font(.title).fontWeight(.light).underline()
            List {
                ForEach(tasks) { task in
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
    
    private var filteredTasks: [CDTask] {
        let currentDate = Date()
        let currentDayStart = Calendar.current.startOfDay(for: currentDate)
        return tasks.filter { task in
            guard let taskDate = task.startDate_ else { return false } // Ensure task has a date
            let taskDayStart = Calendar.current.startOfDay(for: taskDate)
            return taskDayStart == currentDayStart
        }
    }
}

#Preview {
    TaskListScreen()
        .environmentObject(DataSource())
}


