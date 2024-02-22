//
//  weekView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 2/18/24.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var dataSource: DataSource
    
    @State private var showingDayView = false
    @State private var sendCount = 0
    @State private var sendDate = ""
    @State private var week = 0
    
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
        VStack {
            HStack {
                Spacer()
                Button(action: previousWeek) {
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
                
                Button(action: nextWeek) {
                    Image(systemName: "arrow.right")
                        .imageScale(.medium)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(dataSource.selectedTheme.buttonColor)
                        .padding(.trailing, 50)
                }
                Spacer()
            }
            weekGrid
        }
        .background(dataSource.selectedTheme.backgroundColor)
//        .padding(.bottom, 20)
        
        
    }
    
    var weekGrid: some View {
        
        VStack {
            ForEach(1..<8) {
                row in
                let count = row + (week * 7)
                WeekCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                    .environmentObject(dateHolder)
                    .onTapGesture {
                        showingDayView.toggle()
                        sendCount = count
                        sendDate = CalendarHelper().monthYearString(dateHolder.date)
                        
                    }
            }
        }
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $showingDayView) {
            DayView(count: sendCount, startingSpaces: startingSpaces,  daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, sendDate: formattedDate)
        }
        
    }
    
    func previousWeek() {
        if (week > 0) {
            week -= 1
        }
    }
    
    func nextWeek() {
        if (week < 5) {
            week += 1
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
            .environmentObject(DateHolder())
            .environmentObject(DataSource())
    }
}