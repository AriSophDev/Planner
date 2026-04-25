//
//  Theme.swift
//  Planner
//
//  Created by Topi on 25/04/26.
//

import SwiftUI

extension Color {
    static let daynestBackground = Color(red: 0.98, green: 0.92, blue: 0.84)
    static let daynestAccent = Color(red: 0.85, green: 0.55, blue: 0.35)
    static let daynestCard = Color.white.opacity(0.5)
}

extension ShapeStyle where Self == Color {
    static var daynestBackground: Color { .daynestBackground }
    static var daynestAccent: Color { .daynestAccent }
    static var daynestCard: Color { .daynestCard }
}

