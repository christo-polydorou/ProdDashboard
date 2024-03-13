//
//  CalendarCell.swift
//  
//
//  Created by Cole Roseth on 1/30/24.
//

import SwiftUI

// creates the rectangle that contains that given day.
struct CalendarCell: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy)
    var tasks: FetchedResults<CDTask>
    
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var dataSource: DataSource

    //variables that help create a viewable struct of a date
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    
    
    
    
    var body: some View {
        
        Rectangle().foregroundColor(.clear) // defines the rectangle shape
            .background(cellColor)
            .edgesIgnoringSafeArea(.all) // Background Color
            .overlay(
                VStack {
                    Text(monthStruct().day())
                    .foregroundColor(textColor(type: monthStruct().monthType))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .cornerRadius(5)
                    .font(.system(size: 16))
                    .padding(.bottom, 30)
                }
            )
            .frame(maxWidth: 100, maxHeight: .infinity)
                    .cornerRadius(10)

    }

    // creates a gradient cell color with temperature based on the number of tasks on that day.
    private var cellColor: Color {
        let taskCount = filteredTasks.count
        let maxTaskCount = 10 // Define the maximum task count to adjust the darkness
        let maxDarkness: Double = 0.5 // Define the maximum darkness
        
        // Calculate the darkness based on the task count
        let darkness = min(1.0, Double(taskCount) / Double(maxTaskCount)) * maxDarkness
        
        // Get the base color components
        let baseColor = Color(.white)
        var baseRed: CGFloat = 0
        var baseGreen: CGFloat = 0
        var baseBlue: CGFloat = 0
        UIColor(baseColor).getRed(&baseRed, green: &baseGreen, blue: &baseBlue, alpha: nil)
        
        // Calculate the adjusted color with darkness
        let adjustedRed = max(0, baseRed - CGFloat(darkness))
        let adjustedGreen = max(0, baseGreen - CGFloat(darkness))
        let adjustedBlue = max(0, baseBlue - CGFloat(darkness))
        
        return Color(red: Double(adjustedRed), green: Double(adjustedGreen), blue: Double(adjustedBlue))
    }
    
    
    

    // method that accesses that list of task objects stored in core data, filters them and
    // returns a new list of tasks that are on the day of the date sent to calendarCell
    private var filteredTasks: [CDTask] {
        let currentDayString = monthStruct().day()
        let currentDayDate = Calendar.current.date(bySetting: .day, value: Int(currentDayString)!, of: Date())!

        return tasks.filter { task in
            guard let taskDate = task.startDate_ else { return false }
            let taskDayDate = Calendar.current.startOfDay(for: taskDate)
            return Calendar.current.isDate(taskDayDate, inSameDayAs: currentDayDate)
        }
    }
    
    
    // color of the number in the cell based on if that number is within the range of the month
    func textColor(type: MonthType) -> Color {
        return type == MonthType.current ? Color.black: Color.gray
    }

    // creates a structure that provides information to the MonthView about the current day and the range of that month/which month it is
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

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
    }
}
 
