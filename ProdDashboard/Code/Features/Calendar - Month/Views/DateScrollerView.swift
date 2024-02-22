//
//  DateScrollerView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 1/30/24.
//

import SwiftUI

struct DateScrollerView: View {
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var dataSource: DataSource
    
    @State private var showingDayView = false
    @State private var sendCount = 0
    @State private var sendDate = ""
    
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
    
    var body: some View {
//        Rectangle().foregroundColor(.clear).background(Color(red: 1, green: 0.95, blue: 0.91)).edgesIgnoringSafeArea(.all) // Background Color
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
    
    func previousMonth() {
        dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
    }

    func nextMonth() {
        dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
    }
    
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

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}
