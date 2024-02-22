//
//  MLActions.swift
//  ProdDashboard
//
//  Created by Aidan Morris on 2/13/24.
//

import Foundation
import CoreML

func getPrediction(name: String, tag: String, startDate: Date) -> Double {
    // let model = DurationModelCyclical()
    let model = prodDashReg_1()
    let seconds = getSecondsFromDate(date: startDate)
    let secondsX = cos((seconds / 86400) * 2 * Double.pi)
    let secondsY = sin((seconds / 86400) * 2 * Double.pi)
    do {
        //print("Name: \(name), Tag: \(tag), startTime: \(getTimeFromSeconds(time: seconds))")
        let modelOutput = try model.prediction(Name: name, Tags: tag, sin: secondsY, cos: secondsX)
        return round(modelOutput.Real)
    } catch {
        print("Error getting prediction: \(error)")
        return -1.0
    }
}

func recommendTime(name: String, tag: String, freeTimes: [DateInterval]) -> Date {
    var lowestDuration = Double.infinity
    var lowestDurationDate = Date()
    for interval in freeTimes {
        var curStart = interval.start
        // print("Interval Start: \(convertDateToTimeString(date: interval.start))")
        // print("Interval End: \(convertDateToTimeString(date: interval.end))")

        while curStart < interval.end {
            let pred = getPrediction(name: name, tag: tag, startDate: curStart)
            print(convertDateToTimeString(date: curStart) + " Prediction: \(pred)")
            if pred < lowestDuration {
                lowestDuration = pred
                lowestDurationDate = curStart
            }
            curStart = curStart.addingTimeInterval(15 * 60)
        }
    }
    return lowestDurationDate
}

func getRecommendation(name: String, tag: String, startDate: Date) -> ((String, String), (Double, Date)) {
    let suggestedName = findClosestMatch(for: name, columnName: "Name") ?? "No match found"
    let suggestedTag = findClosestMatch(for: tag, columnName: "Tags") ?? "No match found"
    let pred = getPrediction(name: suggestedName, tag: suggestedTag, startDate: startDate)
    
    print("Suggested Name: \(suggestedName), Suggested Tag: \(suggestedTag)")
    
    // FOR TESTING
    let calendar = Calendar.current
    
    var startComponents = DateComponents()
    startComponents.month = 4
    startComponents.day = 14
    startComponents.hour = 08
    startComponents.minute = 00
    let startDate = calendar.date(from: startComponents)
    
    var endComponents = DateComponents()
    endComponents.month = 4
    endComponents.day = 14
    endComponents.hour = 12
    endComponents.minute = 00
    let endDate = calendar.date(from: endComponents)
    
    let testInterval = DateInterval(start: startDate ?? Date(), end: endDate ?? Date())
    // END
    
    let recStart = recommendTime(name: suggestedName, tag: suggestedTag, freeTimes: [testInterval])
    print("Suggested Name: \(suggestedName), Suggested Tag: \(suggestedTag), Prediction: \(pred) minutes: Recommended Start: \(convertDateToTimeString(date: recStart))")
    return ((suggestedName, suggestedTag), (pred, recStart))
}

func getTimeFromSeconds(time: Double) -> String {
    var curTime = Int(time)
    let hours = curTime / 3600
    curTime = curTime % 3600
    let minutes = curTime / 60
    let seconds = curTime % 60
    var amPm: String
    if hours > 12 {
        amPm = "PM"
    } else {
        amPm = "AM"
    }
    return "\(hours):\(minutes):\(seconds) " + amPm
}

func getSecondsFromDate(date: Date) -> Double {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date) * 3600
    let minutes = calendar.component(.minute, from: date) * 60
    let seconds = calendar.component(.second, from: date)
    return Double(hour + minutes + seconds)
}    

func convertDateToTimeString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm:ss a"
    return formatter.string(from: date)
}



//
//func updateModel(task: CDTask) {
//    var featureProviders = [MLFeatureProvider]()
//    
//    let nameLabel = "Name"
//    let tagLabel = "Tags"
//    let sinLabel = "sin"
//    let cosLabel = "cos"
//    
//    let nameValue = MLFeatureValue(task.name)
//    let tagValue = MLFeatureValue(task.tag)
//    let sinValue = MLFeatureValue(task.sin)
//    let cosValue = MLFeatureValue(task.cos)
//    
//    let dataPointFeatures: [String: MLFeatureValue] = [nameLabel: nameValue,
//                                                        tagLabel: tagValue,
//                                                        sinLabel: sinValue,
//                                                        cosLabel: cosValue]
//    
//    if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
//        featureProviders.append(provider)
//    }
//    
//    guard let modelURL = Bundle.main.url(forResource: "prodDashReg_1", withExtension: "mlmodel") else {
//        fatalError("Failed to load model")
//    }
//    
//
//    
//    let trainingData = MLArrayBatchProvider(array: featureProviders)
//    
//    guard let updateTask = try? MLUpdateTask(forModelAt: modelURL, trainingData: trainingData, completionHandler: updateContext)
//    
//}
