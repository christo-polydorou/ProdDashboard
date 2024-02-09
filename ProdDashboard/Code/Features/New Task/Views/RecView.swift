//
//  RecView.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 2/5/24.
//

import SwiftUI

struct RecView: View {
    var body: some View {
        // let result = String(getPrediction(name: "Make Bed", expect: 3, personal: 1))
        // Text(result)
        
        
        let testInterval = getTempDate()
        
        let recommendedStart = recommendTime(taskName: "Laundry", taskExpect: 3, taskPersonal: 1, freeTimes: [testInterval])
        
        
        
        var formattedTime: String {
            let timeInterval = TimeInterval(recommendedStart)
            let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
            let resultDate = referenceDate.addingTimeInterval(timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.string(from: resultDate)
            
        }
        
        Text(formattedTime)
    }
}

#Preview {
    RecView()
}
