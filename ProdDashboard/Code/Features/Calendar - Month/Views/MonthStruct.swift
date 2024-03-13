//
//  MonthStruct.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 1/30/24.
//

import Foundation

// defines the month structure to build monthView and weekView
struct MonthStruct {
    var monthType: MonthType
    var dayInt: Int
    func day() -> String {
        return String(dayInt)
    }
}

// how calendar differentiates past, present and future months.
enum MonthType {
    case previous
    case current
    case next
}
