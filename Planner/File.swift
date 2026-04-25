//
//  File.swift
//  Planner
//
//  Created by Topi on 25/04/26.
//

import Foundation

struct TaskItem: Identifiable {
    let id = UUID()
    var tittle: String
    var IsCompleted: Bool = false
    
}
