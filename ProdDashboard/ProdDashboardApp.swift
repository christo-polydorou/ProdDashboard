//
//  ProdDashboardApp.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 12/21/23.
//

import SwiftUI

@main
struct ProdDashboardApp: App {
    
//    @StateObject private var dataController = DataController()
    let dataController = DataController.shared
    let dateHolder = DateHolder()
    let dataSource = DataSource()
    
    var body: some Scene {
        WindowGroup {
            WrapperView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dateHolder)
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(dataSource)
        }
    }
}
