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
    
    @Environment(\.managedObjectContext) var context
    @State private var addTask = false
    
        
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(Color(red: 1, green: 0.95, blue: 0.91)).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                HStack {
                    Text("Today").font(Font.custom("Montserrat", size: 50)) // Title
                    Spacer()
                    Button("+ Add Task") {
                        addTask.toggle()
                    }.modifier(NewTaskButton())
                }.padding(.leading).padding(.trailing)
                let date = Date().formatted(date: .abbreviated, time: .omitted)
                Text(date).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 25).padding(.bottom, 25).fontWeight(.light) // Date
                UncompletedSection()
                CompletedSection()
//                NavigationMenu().offset(y: 20)
            }
            .sheet(isPresented: $addTask) {
                AddTaskView()
            }
        }
        
    }
    
    
}

struct UncompletedSection: View {

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
}


struct CompletedSection: View {
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
}


