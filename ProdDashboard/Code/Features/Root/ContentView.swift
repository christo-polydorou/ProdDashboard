//
//  ContentView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 12/19/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var task: FetchedResults<Task>
    
    @State private var showingAddView = false
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                Text("\(Int(totalCaloriesToday())) KCal (Today)")
//                    .foregroundColor(.gray)
//                    .padding([.horizontal])
                List {
                    ForEach(task) { task in
                        NavigationLink(destination: EditTaskView(task: task)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(task.name!)
                                        .bold()
                                }
                                Spacer()
                          
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Taskify")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                        editMode = .inactive
                    } label: {
                        Label("Add Task", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        .environment(\.editMode, $editMode)
        .navigationViewStyle(.stack) // Removes sidebar on iPad
    }
    
//     Deletes food at the current offset
    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { task[$0] }
            .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
    
    // Calculates the total calories consumed today
//    private func totalCaloriesToday() -> Double {
//        var caloriesToday: Double = 0
//        for item in food {
//            if Calendar.current.isDateInToday(item.date!) {
//                caloriesToday += item.calories
//            }
//        }
//        print("Calories today: \(caloriesToday)")
//        return caloriesToday
//    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
