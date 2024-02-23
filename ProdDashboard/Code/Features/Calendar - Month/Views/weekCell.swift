//
//  weekCell.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 2/18/24.
//

import SwiftUI

struct WeekCell: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dataSource: DataSource
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    @EnvironmentObject var dateHolder: DateHolder
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int

    var body: some View {
        
        Rectangle().foregroundColor(.clear)
            .background(.white)
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
                                        Text(getHourAndMinute(from: task.startDate))
                                    }.frame(width: 135, height: 15, alignment: .leading)
                                        
                                }
                                .background(backgroundColorForTag())
                                
                            }
                        }.onDelete(perform: deleteTask)
                
                    }.scrollContentBackground(.hidden)
                        
                }
            )
            .frame(maxWidth: 350, maxHeight: 82)
                    .cornerRadius(10)
//                    .shadow(radius: 3, y: 5)
    }
    
    
    private func backgroundColorForTag() -> Color {
        guard let taskTag = filteredTasks.first?.tag else { return .clear } // Assuming the tag is taken from the first task
        switch taskTag {
            case "Health & Wellness":
                return Color.red
            case "Daily Life & Errands":
                return Color.orange
            case "Meal & Meal Prep":
                return Color.yellow
            case "Work & Internships":
                return Color.green
            case "Academic Work":
                return Color.blue
            case "Research & Reading":
                return Color.purple
            case "Household Chores":
                return Color.gray
            case "Personal Development":
                return Color.pink
            case "General":
                return Color.black
            case "Exercise & Fitness":
                return Color.primary
            default:
                return Color.secondary
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
