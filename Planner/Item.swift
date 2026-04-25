import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var title: String
    var isCompleted: Bool
    
    init(timestamp: Date = Date(), title: String = "", isCompleted: Bool = false) {
        self.timestamp = timestamp
        self.title = title
        self.isCompleted = isCompleted
    }
}
