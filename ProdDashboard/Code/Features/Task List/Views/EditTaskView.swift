//
//  EditTaskView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import Foundation
import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var task: FetchedResults<Task>.Element
    
    @State private var name = ""
    @State private var date: Double = 0
    
    var body: some View {
        Form {
            Section() {
                TextField("\(task.name!)", text: $name)
                    .onAppear {
                        name = task.name!
                    }
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        DataController().editTask(task: task, name: name, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}
