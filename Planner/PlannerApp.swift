//
//  PlannerApp.swift
//  Planner
//
//  Created by Topi on 25/04/26.
//

import SwiftUI
import SwiftData

@main
struct PlannerApp: App {
    var body: some Scene {
        WindowGroup {
            ModelContextWrapper()
        }
        .modelContainer(for: Item.self)
    }
}

struct ModelContextWrapper: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ContentView(modelContext: modelContext)
    }
}
