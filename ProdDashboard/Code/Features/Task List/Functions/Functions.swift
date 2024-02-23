//
//  Functions.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 2/22/24.
//

import Foundation
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
