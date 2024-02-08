//
//  DateScrollerView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 1/30/24.
//

import SwiftUI

struct DateScrollerView: View {
    @EnvironmentObject var dateHolder: DateHolder
    
    @State private var showingDayView = false
    @State private var sendCount = 0
    @State private var sendDate = ""
    
    
    //feature freeze 15th code freeze 22nd
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: previousMonth) {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                        .font(Font.title.weight(.bold))
                }
                
                Text(CalendarHelper().monthYearString(dateHolder.date))
                    .font(.title)
                    .bold()
                    .animation(.none)
                    .frame(maxWidth: .infinity)
                
                Button(action: nextMonth) {
                    Image(systemName: "arrow.right")
                        .imageScale(.large)
                        .font(Font.title.weight(.bold))
                }
                
                
                
                
                
                Spacer()
                
            }
            daysOfWeekStack
            calendarGrid
        }
        
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
        
        VStack(spacing: 1) {
            let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date) //temp
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
            let prevMonth = CalendarHelper().minusMonth(dateHolder.date) //temp
            let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
           // let sendDate = CalendarHelper().monthYearString(dateHolder.date)
            
            
            ForEach(0..<6) {
                row in
                HStack(spacing: 1) {
                    ForEach(1..<8) {
                        column in
                        let count = column + (row * 7)
                           // EmptyView()
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                            .onTapGesture {
                                showingDayView.toggle()
                                sendCount = count
                                sendDate = CalendarHelper().monthYearString(dateHolder.date)
                                
                            }
                            
                                                //.hidden()
                        
                    }
                }
            }
            NavigationLink(destination: DayView(count: sendCount,
                                                startingSpaces: startingSpaces,
                                                daysInMonth: daysInMonth,
                                                daysInPrevMonth: daysInPrevMonth, sendDate: sendDate), isActive: $showingDayView) {
                        EmptyView()
                    }
                    .hidden()
            
            
        }.frame(maxHeight: .infinity)
    }
    
    
}



struct DateScrollerView_Previews: PreviewProvider {
    static var previews: some View {
        DateScrollerView()
    }
}
