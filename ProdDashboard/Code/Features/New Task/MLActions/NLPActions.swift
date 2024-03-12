//  NLPActions.swift
//  ProdDashboard

import Foundation
import NaturalLanguage

/*
 Inputs: input - String to match to dataset;
         columnName - String representing column to match input to
 
 Output: String optional representing closest matching string for given input; Returns input name if no close match found
 
 Calls embedding function and calculates distance between the input string and datapoints in ML model training set
 */
func findClosestMatch(for input: String, columnName: String) -> String? {
        let dataSet = loadDataSetFromCSV(columnName: columnName)
        let embedding = NLEmbedding.sentenceEmbedding(for: .english)
        
        var closestMatch: String?
        var smallestDistance: Double = Double.greatestFiniteMagnitude
        
        for dataPoint in dataSet {
            if let distance = embedding?.distance(between: dataPoint.lowercased(), and: input.lowercased()) {
                if distance < smallestDistance {
                    smallestDistance = distance
                    closestMatch = dataPoint
                }
            }
        }
        if smallestDistance > 1.0 {
            return input
        } else {
            return closestMatch
        }
    }


/*
 Input: columnName - String reprsenting column to load from CSV
 
 Output: Array of strings containing observations from given column
 */
func loadDataSetFromCSV(columnName: String) -> [String] {
    guard let filepath = Bundle.main.path(forResource: "prodData_cyclical", ofType: "csv") else {
        print("CSV file not found")
        return []
    }
    do {
        let data = try String(contentsOfFile: filepath, encoding: .utf8)
        var result: [String] = []
        let rows = data.components(separatedBy: "\n")
        let columnNames = rows.first?.components(separatedBy: ",") ?? []
        guard let nameIndex = columnNames.firstIndex(of: columnName) else {
            print(columnName + " column not found")
            return []
        }
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            if columns.count > nameIndex {
                let name = columns[nameIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                result.append(name)
            }
        }
        return result
    } catch {
        print("Error reading CSV file: \(error)")
        return []
    }
}
