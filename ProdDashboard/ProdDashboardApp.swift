//
//  ProdDashboardApp.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 12/21/23.
//

import SwiftUI

@main
struct ProdDashboardApp: App {
    
    @StateObject private var dataController = DataController()
    
    
    var body: some Scene {
        WindowGroup {
            
            let dateHolder = DateHolder()
            
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dateHolder)
        }
    }
}
