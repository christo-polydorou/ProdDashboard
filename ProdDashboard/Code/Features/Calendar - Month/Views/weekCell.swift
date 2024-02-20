//
//  weekCell.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 2/18/24.
//

import SwiftUI

struct WeekCell: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    @EnvironmentObject var dateHolder: DateHolder
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    //var sendDate: String
    
    
    
    var body: some View {
        
        Rectangle().foregroundColor(.clear)
            .background(Color(red: 0.96, green: 0.89, blue: 0.83))
            .edgesIgnoringSafeArea(.all) // Background Color
            .overlay(
                HStack {
                   Text(monthStruct().day())
                        .foregroundColor(textColor(type: monthStruct().monthType))
                        //.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(5)
                        .bold()
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
                                        Text(task.name).bold().frame(width: 135, height: 10, alignment: .leading)
                                    }
                                    HStack {
                                        Image(systemName: "calendar.badge.clock")
                                            .font(.system(size: 15, weight: .light))
                                        Text("insert start date")
                                    }.frame(width: 135, height: 15, alignment: .leading)
                                        
                                }
                            }
                        }.onDelete(perform: deleteTask)
                    }.scrollContentBackground(.hidden)
                    
                    
                }
            )
            //.padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(5)
                    .shadow(radius: 3, y: 5)
        
        
        
        
        
        
//        Text(monthStruct().day())
//            .foregroundColor(textColor(type: monthStruct().monthType))
//            //.background(Color(red: 0.02, green: 0.47, blue: 0.34))
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .cornerRadius(5).shadow(radius: 3, y: 5)
    }
    
    
    private func deleteTask(offsets: IndexSet) {
            withAnimation {
                offsets.map { tasks[$0] }
                    .forEach(context.delete)
                
                DataController.shared.save()
            }
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
    
    
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.current ? Color.black: Color.gray
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
}

struct WeekCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
    }
}
 

