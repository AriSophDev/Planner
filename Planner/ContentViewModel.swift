import SwiftUI
import SwiftData

@Observable
class ContentViewModel {
    var selectedDate: Date = Date()
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addNewItem() {
        let newItem = Item(timestamp: selectedDate, title: "New Task")
        modelContext.insert(newItem)
        try? modelContext.save()
    }

    func deleteItem(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
    
    func getWeekDays() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }
}
