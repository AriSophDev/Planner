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
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
