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
                    Button(action: { viewMode = .week }) {
                        Text("Week")
                            .font(.custom("GoogleSansFlex-Regular", size: 14))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(viewMode == .week ? Color.white : Color.clear)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: { viewMode = .month }) {
                        Text("Month")
                            .font(.custom("GoogleSansFlex-Regular", size: 14))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 24)
                            .background(viewMode == .month ? Color.white : Color.clear)
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
                            .font(.custom("GoogleSansFlex-Regular", size: 12))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Calendar Grid
                calendarGrid
                    .padding(.horizontal)
                
                Spacer()
                
                // Task Section
                taskSection
            }
        }
    }
    
    private var calendarGrid: some View {
        let days = generateDaysInMonth(for: selectedDate)
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 15) {
            ForEach(days, id: \.self) { date in
                if let date = date {
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.custom("GoogleSansFlex-Regular", size: 14))
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
                            .font(.custom("GoogleSansFlex-Regular", size: 14))
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(filteredItems) { item in
                            HStack(spacing: 12) {
                                Circle()
                                    .stroke(Color.daynestAccent, lineWidth: 2)
                                    .frame(width: 12, height: 12)
                                
                                Text(item.title)
                                    .font(.custom("GoogleSansFlex-Regular", size: 16))
                                    .strikethrough(item.isCompleted)
                                    .foregroundStyle(item.isCompleted ? .gray : .black)
                            }
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
    
    private func hasTasks(on date: Date) -> Bool {
        allItems.contains { calendar.isDate($0.timestamp, inSameDayAs: date) }
    }
}


#Preview{
    CalendarView()
}
