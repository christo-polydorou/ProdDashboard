//
//  Task+helper.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/11/24.
//


import Foundation
import SwiftUI
import CoreData

extension Task {
    
    var name1: String {
        get { name ?? ""}
        set { name = newValue }
    }
//    
    var date1: Date {
        get { date ?? Date() }
        set { date = newValue }
    }
    
    
    
//    convenience init(name: String,
//                     startDate: Date,
//                     context: NSManagedObjectContext){
//        self.init(context: context)
//        self.name = name
//        self.date = startDate
//    }
    
//    static func delete(task: Task) {
//        guard let context = task.managedObjectContext else { return }
//        
//        context.delete(task)
//    }
    
//    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<Task> {
//        let request = Task.fetchRequest()
////        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.date_, ascending: true)]
//        request.sortDescriptors = []
//        request.predicate = predicate
//        return request
//    }

//    // Called when object is created for first time
//    public override func awakeFromInsert() {
//
//    }
}

