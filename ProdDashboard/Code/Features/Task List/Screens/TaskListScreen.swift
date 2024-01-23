//
//  TaskListScreen.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 1/21/24.
//

import SwiftUI

struct TaskListScreen: View {
    @State private var tasks = [
        Task(name: "Meeting", date: "Oct. 22", time: "12:00", isCompleted: false),
        Task(name: "Dinner", date: "Nov. 1", time: "1:00", isCompleted: false),
        Task(name: "Laundry", date: "Jan. 30", time: "3:00", isCompleted: false),
        Task(name: "Homework", date: "Jul. 17", time: "3:00", isCompleted: false),
        Task(name: "Clean", date: "Aug. 19", time: "4:00", isCompleted: false)
    ] // Temp Tasks
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(Color(red: 1, green: 0.95, blue: 0.91)).edgesIgnoringSafeArea(.all) // Background Color
            VStack {
                HStack {
                    Text("Today").font(Font.custom("Montserrat", size: 50)) // Title
                    Spacer()
                    Button("+ Add Task") { // Add Task Button
                        // New Task Screen
                    }.modifier(NewTaskButton())
                }.padding(.leading).padding(.trailing)
                let date = Date().formatted(date: .abbreviated, time: .omitted)
                Text(date).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 25).padding(.bottom, 25).fontWeight(.light) // Date
                UncompletedSection(tasks: $tasks)
                CompletedSection(tasks: $tasks)
                NavigationMenu().offset(y: 20)
            }
        }
    }
}

struct UncompletedSection: View {
    @Binding var tasks: [Task]
    var body: some View {
        VStack {
            Text("Tasks").offset(x: -135, y: 12).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.light).underline()
            List {
                ForEach(tasks.indices, id: \.self) { index in
                    if !tasks[index].isCompleted {
                        Toggle(isOn: $tasks[index].isCompleted) {
                            VStack {
                                Text(tasks[index].name).bold().frame(width: 175, height: 15, alignment: .leading)
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 20, weight: .light))
                                    Text(tasks[index].date)
                                    Text(tasks[index].time)
                                }.frame(width: 175, height: 15, alignment: .leading)
                            }
                        }.toggleStyle(Checkbox())
                    }
                }
            }.scrollContentBackground(.hidden)
        }
    }
}

struct CompletedSection: View {
    @Binding var tasks: [Task]
    var body: some View {
        Text("Completed").offset(x: -100, y: 12).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.light).underline()
        List {
            ForEach(tasks.indices, id: \.self) { index in
                if tasks[index].isCompleted {
                    Toggle(isOn: $tasks[index].isCompleted) {
                        VStack {
                            Text(tasks[index].name).bold().frame(width: 175, height: 15, alignment: .leading)
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 20, weight: .light))
                                Text(tasks[index].date)
                                Text(tasks[index].time)
                            }.frame(width: 175, height: 15, alignment: .leading)
                        }
                    }.toggleStyle(Checkbox())
                }
            }
        }.scrollContentBackground(.hidden)
    }
}

struct Task: Identifiable {
    var name: String
    var date: String
    var time: String
    var isCompleted: Bool
    let id = UUID()
}

#Preview {
    TaskListScreen()
}
