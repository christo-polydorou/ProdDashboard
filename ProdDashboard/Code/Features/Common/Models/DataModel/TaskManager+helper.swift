//
//  TaskManager+helper.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 2/11/24.
//

import Foundation
import CoreData
import SwiftUI

extension CDTask {
    
    var uuid: UUID {
        get { uuid_ ?? UUID() }
    }
    
    var name: String {
        get { name_ ?? ""}
        set { name_ = newValue }
    }
//
    var startDate: Date {
        get { startDate_ ?? Date() }
        set { startDate_ = newValue }
    }
    
    var duration: Double {
        get { duration_ }
        set { duration_ = newValue }
    }
    
    var tag: String {
        get { tag_ ?? ""}
        set { tag_ = newValue }
    }
    
    convenience init(name: String,
                     startDate: Date, 
                     context: NSManagedObjectContext){
        self.init(context: context)
        self.name = name
        self.startDate = startDate
    }
    
    public override func awakeFromInsert() {
        self.uuid_ = UUID()
    }
    
    static func delete(task: CDTask) {
        guard let context = task.managedObjectContext else { return }
        
        context.delete(task)
    }
    
    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<CDTask> {
        let request = CDTask.fetchRequest()
        request.sortDescriptors = []
        request.predicate = predicate
        
        return request
    }
    
//    static func fetchCurrDate(_ predicate: NSPredicate = .all) -> NSFetchRequest<CDTask> ) {
//        
//    }
    
}
