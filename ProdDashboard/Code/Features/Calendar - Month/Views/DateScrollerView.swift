//
//  DateScrollerView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 1/30/24.
//

import SwiftUI

// DateScrollerView defines the Month View
struct DateScrollerView: View {
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var dataSource: DataSource
    
    @State private var showingDayView = false
    @State private var sendCount = 0 // temp variable that sends the dayView the selected day
    @State private var sendDate = "" // temp variable that sends the dayview the selected date

    // helper methods that calculate dates and calendar information from the dateHolder variable
    private var daysInMonth: Int {
            CalendarHelper().daysInMonth(dateHolder.date)
        }
        
        private var firstDayOfMonth: Date {
            CalendarHelper().firstOfMonth(dateHolder.date)
        }
        
        private var startingSpaces: Int {
            CalendarHelper().weekDay(firstDayOfMonth)
        }
        
        private var prevMonth: Date {
            CalendarHelper().minusMonth(dateHolder.date)
        }
        
        private var daysInPrevMonth: Int {
            CalendarHelper().daysInMonth(prevMonth)
        }
        
        private var formattedDate: String {
            CalendarHelper().monthYearString(dateHolder.date)
        }

    // defines the MonthView screen
    var body: some View {

        VStack {
            HStack {
                Spacer()
                Button(action: previousMonth) {
                    Image(systemName: "arrow.left")
                        .imageScale(.medium)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(dataSource.selectedTheme.buttonColor)
                        .padding(.leading, 50)
                }
                
                Text(CalendarHelper().monthYearString(dateHolder.date))
                    .font(.title)
                    .bold()
                    .animation(.none)
                    .frame(maxWidth: .infinity)
                
                Button(action: nextMonth) {
                    Image(systemName: "arrow.right")
                        .imageScale(.medium)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(dataSource.selectedTheme.buttonColor)
                        .padding(.trailing, 50)
                }
                Spacer()
            }
            daysOfWeekStack
            calendarGrid
        }
        .background(dataSource.selectedTheme.backgroundColor)
    }
    
    func previousMonth() { // changes the month in month view
        dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
    }

    func nextMonth() { 
        dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
    }

    // creates the visual row of weekdays
    var daysOfWeekStack: some View {
        HStack(spacing: 1) {
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
        }
    }

      // defines the grid of calendarCell structs with CalendarCell structs, on clicking, sends you to a DayView
    var calendarGrid: some View {
        
        VStack(spacing: 10) {
            
            ForEach(0..<6) {
                row in
                HStack(spacing: 5) {
                    ForEach(1..<8) {
                        column in
                        let count = column + (row * 7)
                        
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                            .onTapGesture {
                                showingDayView.toggle()
                                sendCount = count
                                sendDate = CalendarHelper().monthYearString(dateHolder.date)
                                
                            }
                    }
                }
                .padding(.trailing, 10)
                .padding(.leading, 10)
            }
        
        }
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $showingDayView) {
            DayView(count: sendCount, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, sendDate: formattedDate)
        }
        .padding(.bottom, 20)
    }
}

struct DateScrollerView_Previews: PreviewProvider {
    static var previews: some View {
        DateScrollerView()
            .environmentObject(DataSource())
            .environmentObject(DateHolder())
    }
}

// returns the horizontal list of days for a view
extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}
