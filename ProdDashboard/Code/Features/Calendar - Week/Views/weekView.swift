//
//  weekView.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 2/18/24.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var dateHolder: DateHolder
    
    @State private var showingDayView = false
    @State private var sendCount = 0
    @State private var sendDate = ""
    @State private var week = 0
    
    //var count: Int
    
    
    //feature freeze 15th code freeze 22nd
    
    
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
                Button(action: previousWeek) {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(Color(red: 0.02, green: 0.47, blue: 0.34))
                }
                
                Text(CalendarHelper().monthYearString(dateHolder.date))
                    .font(.title)
                    .bold()
                    .animation(.none)
                    .frame(maxWidth: .infinity)
                
                Button(action: nextWeek) {
                    Image(systemName: "arrow.right")
                        .imageScale(.large)
                        .font(Font.title.weight(.bold))
                        .foregroundColor(Color(red: 0.02, green: 0.47, blue: 0.34))
                }
                
                
                
                
                
                Spacer()
                
            }
            //daysOfWeekStack
            weekGrid2
        }
        .background(Color(red: 1, green: 0.95, blue: 0.91))
        
        
    }
    
//    func previousMonth() {
//        dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
//    }
//
//    func nextMonth() {
//        dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
//    }
//    func previousWeek() {
//        dateHolder.date = CalendarHelper().minusWeek(dateHolder.date)
//    }
//    
//    func nextWeek() {
//        dateHolder.date = CalendarHelper().plusWeek(dateHolder.date)
//    }
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
    
    
    
    
//    var daysOfWeekStack: some View {
//        HStack(spacing: 1) {
//            Text("Sun").dayOfWeek()
//            Text("Mon").dayOfWeek()
//            Text("Tue").dayOfWeek()
//            Text("Wed").dayOfWeek()
//            Text("Thu").dayOfWeek()
//            Text("Fri").dayOfWeek()
//            Text("Sat").dayOfWeek()
//        }
//    }

    var weekGrid: some View {
        
        
        
            
            HStack(spacing: 1) {
                ForEach(1..<8) {
                    column in
                    let count = column + (week * 7)
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
                
                
                //            NavigationLink(destination: DayView(count: sendCount,
                //                                                startingSpaces: startingSpaces,
                //                                                daysInMonth: daysInMonth,
                //                                                daysInPrevMonth: daysInPrevMonth, sendDate: sendDate), isActive: $showingDayView) {
                //                        EmptyView()
                //                    }
                //                    .hidden()
                
                
            }
            .frame(maxHeight: .infinity)
            .sheet(isPresented: $showingDayView) {
                DayView(count: sendCount, startingSpaces: startingSpaces,  daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, sendDate: formattedDate)
            }
            
        
        
    }
    
    
    
    
    
    var weekGrid2: some View {
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
    }
}

//#Preview {
//    weekView()
//}


