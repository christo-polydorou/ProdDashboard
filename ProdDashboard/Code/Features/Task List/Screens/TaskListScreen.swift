//
//  TaskListScreen.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/11/24.
//

import Foundation
import SwiftUI
import CoreData

//defines the main task list and the main dayView of the app.
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
               // displays a list of uncompleted and completed tasks
                UncompletedSection()
                CompletedSection()
            }
            .sheet(isPresented: $addTask) {
                AddTaskView()
            }
        }
    }
}

// displays a list of all uncompleted tasks
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

            }.offset(x: -135, y: 12)

            
            
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
        
            
        }
        .onAppear{
            let tasksCount = tasks.count
            Swift.print("Number of tasks: \(tasksCount)")
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


    // method that accesses that list of task objects stored in core data, filters them and
    // returns a new list of tasks on the current day
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


// displays a list of all completed tasks
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
                                Text(getHourAndMinute(from: task.startDate))
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


