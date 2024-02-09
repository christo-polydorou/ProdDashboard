//
//  ModelActions.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 2/5/24.
//

import Foundation
import CoreML

func getPrediction(name: String, expect: Double, personal: Double) -> Double {
    let model = MyTabularRegressor_3()
    do {
        let modelOutput = try model.prediction(Name: name, Expect: Int64(expect), Personal: Int64(personal))
        return modelOutput.Real
    } catch {
        print("Error getting prediction: \(error)")
        return -1
    }
}


func recommendTime(taskName: String, taskExpect: Double, taskPersonal: Double, freeTimes: [DateInterval]) -> Double {
    // Assume intervals of 15 minutes and only times without other tasks
    var lowestTime = Double.infinity
    for interval in freeTimes {
        var curTime = interval.start
        while curTime != interval.end {
            let curPred = getPrediction(name: taskName, expect: taskExpect, personal: taskPersonal)
            if curPred < lowestTime {
                var doubleValue = curTime.timeIntervalSinceReferenceDate
                
                lowestTime = doubleValue
            }
            curTime = curTime.addingTimeInterval(15 * 60)
        }
    }
    return lowestTime
}

func getTempDate() -> DateInterval {
    var dateComponentsStart = DateComponents()
    dateComponentsStart.year = 2024
    dateComponentsStart.month = 2
    dateComponentsStart.day = 4
    dateComponentsStart.hour = 8
    dateComponentsStart.minute = 0
    
    var dateComponentsEnd = DateComponents()
    dateComponentsEnd.year = 2024
    dateComponentsEnd.month = 2
    dateComponentsEnd.day = 4
    dateComponentsEnd.hour = 20
    dateComponentsEnd.minute = 0
    
    let calendar = Calendar.current
    
    if let dateStart = calendar.date(from: dateComponentsStart),
           let dateEnd = calendar.date(from: dateComponentsEnd) {
            return DateInterval(start: dateStart, end: dateEnd)
    } else {
        return DateInterval()
    }
}


