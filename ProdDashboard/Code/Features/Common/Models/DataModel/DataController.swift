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
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved.")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addTask(name: String, context: NSManagedObjectContext) {
        let task = Task(context: context)
    
//        task.date = Date()
        task.name = name
//        task.recurring = recurring
//        task.id = UUID()
//
        save(context: context)
    }
    
    func editTask(task: Task, name: String, context: NSManagedObjectContext) {
        task.name = name
//        task.date = date
        
        save(context: context)
    }
}
