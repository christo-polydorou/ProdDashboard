//
//  DataController.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TaskModel")
    
    static let shared = DataController()
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        
        let context = container.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("Data saved.")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addTask(name: String, date: Date, dates: [Date], context: NSManagedObjectContext) {
        let task = Task(context: context)
    
        task.name1 = name
        task.date1 = date
//        task.recurring = recurring
//        task.id = UUID()
//
        save()
    }
    
    func editTask(task: Task, name: String, date: Date, context: NSManagedObjectContext) {
        task.name1 = name
        task.date1 = date
        
        save()
    }
    
    
    
}
