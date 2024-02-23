//
//  ScheduleManager.swift
//  ProdDashboard
//
//  Created by Ben Sherrick on 2/22/24.
//

import Foundation

class ScheduleManager: ObservableObject {
    @Published var schedules: [ScheduleEntry] = []
    
    static let shared = ScheduleManager() // Shared instance
    
    init() {} // Private initializer to enforce singleton pattern
}
