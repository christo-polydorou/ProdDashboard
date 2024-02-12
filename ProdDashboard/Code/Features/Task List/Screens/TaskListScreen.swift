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
        
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(Color(red: 1, green: 0.95, blue: 0.91)).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                HStack {
                    Text("Today").font(Font.custom("Montserrat", size: 50)) // Title
                    Spacer()
                    Button("+ Add Task") {
                        
                    }.modifier(NewTaskButton())
                }.padding(.leading).padding(.trailing)
                let date = Date().formatted(date: .abbreviated, time: .omitted)
                Text(date).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 25).padding(.bottom, 25).fontWeight(.light) // Date
                UncompletedSection()
                CompletedSection()
                NavigationMenu().offset(y: 20)
            }
        }
    }
}

struct UncompletedSection: View {

    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    var body: some View {
        VStack {
            Text("To-Do").offset(x: -135, y: 12).font(.title).fontWeight(.light).underline()
            List(tasks) { task in
//                NavigationLink(destination: EditTaskView(task: task)) {
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
//                }
            }.scrollContentBackground(.hidden)
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                    .onEnded { _ in
                        // Perform the action when long press ends
                        // You can show an action sheet or navigate to a delete view here
                        // For simplicity, let's assume you want to delete the task directly
                        CDTask.delete(task: task)                    }
            )
            
                
        }
    }
}


struct CompletedSection: View {
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    var body: some View {
        VStack {
            Text("Completed").offset(x: -135, y: 12).font(.title).fontWeight(.light).underline()
            List(tasks) { task in
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
            }.scrollContentBackground(.hidden)
                
        }
    }
}

#Preview {
    TaskListScreen()
}
