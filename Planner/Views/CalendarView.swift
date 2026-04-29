import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allItems: [Item]
    
    @State private var selectedDate = Date()
    @State private var viewMode: ViewMode = .month
    
    enum ViewMode {
        case week, month
    }
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    var body: some View {
        ZStack {
            Color.daynestBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // View Mode Toggle (Week/Month)
                HStack {
                    Button(action: { 
                        withAnimation(.spring()) {
                            viewMode = .week 
                        }
                    }) {
                        Text("Week")
                            .dynaPuffFont(size: 14)
                            .foregroundStyle(viewMode == .week ? .white : .black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(viewMode == .week ? Color.daynestAccent : Color.clear)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: { 
                        withAnimation(.spring()) {
                            viewMode = .month 
                        }
                    }) {
                        Text("Month")
                            .dynaPuffFont(size: 14)
                            .foregroundStyle(viewMode == .month ? .white : .black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(viewMode == .month ? Color.daynestAccent : Color.clear)
                            .clipShape(Capsule())
                    }
                }
                .padding(4)
                .background(Color.black.opacity(0.05))
                .clipShape(Capsule())
                .padding(.top)
                
                // Calendar Grid Header
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .dynaPuffFont(size: 12)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Calendar Grid
                calendarGrid
                    .padding(.horizontal)
                    .id(viewMode)
                
                Spacer()
                
                // Task Section
                taskSection
            }
        }
    }
    
    private var calendarGrid: some View {
        let days = viewMode == .month ? generateDaysInMonth(for: selectedDate) : generateDaysInWeek(for: selectedDate)
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 15) {
            ForEach(days, id: \.self) { date in
                if let date = date {
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .dynaPuffFont(size: 14)
                            .fontWeight(calendar.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                            .foregroundStyle(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                            .frame(width: 30, height: 30)
                            .background(calendar.isDate(date, inSameDayAs: selectedDate) ? Color.black : Color.clear)
                            .clipShape(Circle())
                        
                        // Dot for tasks
                        if hasTasks(on: date) {
                            Circle()
                                .fill(Color.daynestAccent)
                                .frame(width: 4, height: 4)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedDate = date
                        }
                    }
                } else {
                    Text("")
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
    
    
    private var taskSection: some View {
        VStack {
            // Illustration Placeholder
            VStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.daynestAccent)
                
                Rectangle()
                    .fill(Color.daynestAccent.opacity(0.2))
                    .frame(height: 2)
                    .padding(.horizontal, 40)
            }
            .padding(.vertical)
            
            // Task List
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    let filteredItems = allItems.filter { calendar.isDate($0.timestamp, inSameDayAs: selectedDate) }
                    
                    if filteredItems.isEmpty {
                        Text("No tasks for this day")
                            .dynaPuffFont(size: 14)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(filteredItems) { item in
                            TaskRow(item: item)
                                .padding(.horizontal)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteItem(item)
                                    } label: {
                                        Label("Delete Task", systemImage: "trash")
                                    }
                                }
                        }
                        
                        // Button to add new task
                        Button {
                            addNewItem()
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add new task...")
                            }
                            .dynaPuffFont(size: 16)
                            .foregroundStyle(Color.daynestAccent)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 40, topTrailingRadius: 40)
                .fill(Color.white.opacity(0.3))
        )
    }

    private func addNewItem() {
        let newItem = Item(timestamp: selectedDate, title: "New Task")
        modelContext.insert(newItem)
        try? modelContext.save()
    }

    private func deleteItem(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
    
    // Helper to generate days in the current month
    private func generateDaysInMonth(for date: Date) -> [Date?] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth)
        let offset = weekdayOfFirst - 1 // 0 for Sunday
        
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func generateDaysInWeek(for date: Date) -> [Date?] {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        guard let startOfWeek = calendar.date(from: components) else {
            return []
        }
        
        var days: [Date?] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(date)
            }
        }
        return days
    }
    
    private func hasTasks(on date: Date) -> Bool {
        allItems.contains { calendar.isDate($0.timestamp, inSameDayAs: date) }
    }
}


#Preview{
    CalendarView()
}
