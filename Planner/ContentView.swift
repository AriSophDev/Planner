import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var allItems: [Item]
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // Estado para la fecha seleccionada
    @State private var selectedDate = Date()
    
    // Generar los 7 días de la semana actual
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }
    
    // Filtrar tareas por la fecha seleccionada
    private var filteredItems: [Item] {
        allItems.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.daynestBackground.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header con fecha real
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Tasks")
                                .font(.custom("GoogleSansFlex-Regular", size: 28))
                                .bold()
                            Text(selectedDate.formatted(date: .long, time: .omitted))
                                .font(.custom("GoogleSansFlex-Regular", size: 14))
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: CalendarView()) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundStyle(.daynestAccent)
                                .padding(10)
                                .background(Color.white.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Selector de fechas horizontal REAL
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(weekDays, id: \.self) { date in
                                Button {
                                    withAnimation { selectedDate = date }
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(date.formatted(.dateTime.month(.abbreviated)))
                                            .font(.system(size: 10))
                                        Text(date.formatted(.dateTime.day()))
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .frame(width: 48, height: 64)
                                    .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.daynestAccent : Color.white.opacity(0.3))
                                    .foregroundStyle(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Lista To Do
                    VStack(alignment: .leading, spacing: 15) {
                        Text("To Do")
                            .font(.custom("GoogleSansFlex-Regular", size: 22))
                            .bold()
                        
                        ScrollView {
                            VStack(spacing: 6) {
                                ForEach(filteredItems) { item in
                                    TaskRow(item: item)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                deleteItem(item)
                                            } label: {
                                                Label("Delete Task", systemImage: "trash")
                                            }
                                        }
                                }
                                
                                // Botón para añadir (Corregido)
                                Button {
                                    addNewItem()
                                } label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add new task...")
                                    }
                                    .font(.custom("GoogleSansFlex-Regular", size: 16))
                                    .foregroundStyle(.daynestAccent)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .offset(x: 10)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                // Imagen decorativa del gato
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.daynestAccent.opacity(0.15))
                    .offset(x: 120, y: -20)
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !hasCompletedOnboarding },
            set: { _ in }
        )) {
            OnboardingView()
        }
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
}


#Preview {
    ContentView()
}
