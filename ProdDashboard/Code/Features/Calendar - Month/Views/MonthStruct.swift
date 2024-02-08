//
//  MonthStruct.swift
//  ProdDashboard
//
//  Created by Cole Roseth on 1/30/24.
//

import Foundation

struct MonthStruct {
    var monthType: MonthType
    var dayInt: Int
    func day() -> String {
        return String(dayInt)
    }
}

enum MonthType {
    case previous
    case current
    case next
}
