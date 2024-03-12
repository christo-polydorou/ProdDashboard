//  RecActions.swift
//  ProdDashboard

import Foundation
import CoreML

/*
 Inputs: name - String representing the name of the task;
         tag - String representing the tag of the task;
         startDate - Date representing the day of the task
 
 Output: Double representing the predicted duration in minutes of the inputted task
 
 Converts time components of startDate into seconds and then cyclically encodes them. Calls model prediction on the inputted task and rounds to nearest minute. If no prediction is available, returns -1.
 */
func getPrediction(name: String, tag: String, startDate: Date) -> Double {
    let model = prodDashReg_1()
    let seconds = getSecondsFromDate(date: startDate)
    let secondsX = cos((seconds / 86400) * 2 * Double.pi)
    let secondsY = sin((seconds / 86400) * 2 * Double.pi)
    do {
        let modelOutput = try model.prediction(Name: name, Tags: tag, sin: secondsY, cos: secondsX)
        return round(modelOutput.Real)
    } catch {
        print("Error getting prediction: \(error)")
        return -1.0
    }
}

/*
 Inputs: name - String representing the name of the task;
         tag - String representing the tag of the task;
         freeTimes - List of date intervals representing user's available times for tasks to be scheduled
 
 Output: Date representing recommended start time for the inputted task
 
 Loops through available times and calls model prediction for every 15 minute interval. Keeps track of time with the lowest predicted duration for the task and returns it when loop termiantes.
 */
func recommendTime(name: String, tag: String, freeTimes: [DateInterval]) -> Date {
    var lowestDuration = Double.infinity
    var lowestDurationDate = Date()
    for interval in freeTimes {
        var curStart = interval.start
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

/*
 Input: name - String representing the name of the task;
        tag - String representing the tag of the task;
        startDate - Date representing the day of the task
 
 Output: Tuple of tuples; The first tuple contains the suggested name and tag given by the NLP model; The second tuple contains the predicted duration and recommended start time
 
 Calls NLP model to find closest matching task name and tag in training set to the inputted values. Calls getRecommendation using these suggested values.
 */
func getRecommendation(name: String, tag: String, startDate: Date) -> ((String, String), (Double, Date)) {
    let suggestedName = findClosestMatch(for: name, columnName: "Name") ?? "No match found"
    let suggestedTag = findClosestMatch(for: tag, columnName: "Tags") ?? "No match found"
    let pred = getPrediction(name: suggestedName, tag: suggestedTag, startDate: startDate)
    
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
    
    var recStart = recommendTime(name: suggestedName, tag: suggestedTag, freeTimes: [testInterval])
    print("Suggested Name: \(suggestedName), Suggested Tag: \(suggestedTag), Prediction: \(pred) minutes: Recommended Start: \(convertDateToTimeString(date: recStart))")
    
    
    return ((suggestedName, suggestedTag), (pred, recStart))
}

/*
 Input: time - Double representing the number of seconds from the start of a day
 
 Output: String representing the time of day for the given double
 */
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

/*
 Input: date - Date to convert into seconds
 
 Output: Total seconds from start of the day for the given date
 */
func getSecondsFromDate(date: Date) -> Double {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date) * 3600
    let minutes = calendar.component(.minute, from: date) * 60
    let seconds = calendar.component(.second, from: date)
    return Double(hour + minutes + seconds)
}

/*
 Input: date - Date to convert to a string
 
 Output: String representation of the time components for the given date
 */
func convertDateToTimeString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm:ss a"
    return formatter.string(from: date)
}


/*
 Does not work
 
 Input: task - CDTask to be added to training set

 Creates an updateTask and updates model to retrain it on new task information
 */
func updateModel(task: CDTask) {
    let nameLabel = "Name"
    let tagLabel = "Tags"
    let sinLabel = "sin"
    let cosLabel = "cos"
    
    let nameValue = MLFeatureValue(string: task.name)
    let tagValue = MLFeatureValue(string: task.tag)
    let seconds = getSecondsFromDate(date: task.startDate)
    let secondsX = cos((seconds / 86400) * 2 * Double.pi)
    let secondsY = sin((seconds / 86400) * 2 * Double.pi)
    let sinValue = MLFeatureValue(double: secondsY)
    let cosValue = MLFeatureValue(double: secondsX)

    let dataPointFeatures: [String: MLFeatureValue] = [nameLabel: nameValue,
                                                        tagLabel: tagValue,
                                                        sinLabel: sinValue,
                                                        cosLabel: cosValue]

    guard let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) else {
        print("Error creating feature provider")
        return
    }

    var featureProviders = [MLFeatureProvider]()
    featureProviders.append(provider)

    guard let modelURL = Bundle.main.url(forResource: "prodDashReg 1", withExtension: "mlmodelc") else {
        fatalError("Failed to load model")
    }

    let trainingData = MLArrayBatchProvider(array: featureProviders)

    guard let updateTask = try? MLUpdateTask(forModelAt: modelURL, trainingData: trainingData, completionHandler: { context in
        // Handle the completion of the update task
        if context.task.error != nil {
            print("Model update failed: \(context.task.error!.localizedDescription)")
        } else {
            print("Model update successful.")
        }
    }) else {
        print("Failed to create update task")
        return
    }

    updateTask.resume()
}

/*
 Inputs: date - Date with day, month, and year components to be combined;
         time - Date with time to be combined
 
 Output: Date optional with combined components of inputs
 */
func combineDateWithTime(date: Date, time: Date) -> Date? {
    let calendar = Calendar.current

    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

    var combinedComponents = DateComponents()
    combinedComponents.year = dateComponents.year
    combinedComponents.month = dateComponents.month
    combinedComponents.day = dateComponents.day
    combinedComponents.hour = timeComponents.hour
    combinedComponents.minute = timeComponents.minute

    return calendar.date(from: combinedComponents)
}
