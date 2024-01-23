//
//  DataManager.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

//import Foundation
//import CoreData
//
//
//class DataManager: NSObject, ObservableObject {
//    
//    let container: NSPersistentContainer = NSPersistentContainer(name: "TaskModel")
//    
//    
//    override init() {
//        super.init()
//        container.loadPersistentStores { _, _ in }
//    }
//}
//
//
//func saveTodo(title: String, date: Date, status: String) {
//    let todo = Todo(context: self.viewContext)
//                    todo.id = UUID()
//    todo.title = title
//    todo.date = date
//    todo.status = status
//    
//    do {
//        try self.viewContext.save()
//        print("Todo saved!")
//    } catch {
//        print("whoops \(error.localizedDescription)")
//    }
//}
