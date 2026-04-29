import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var allItems: [Item]
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    @State private var viewModel: ContentViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = State(wrappedValue: ContentViewModel(modelContext: modelContext))
    }
    
    private var filteredItems: [Item] {
        allItems.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: viewModel.selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.daynestBackground.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Tasks")
                                .dynaPuffFont(size: 28)
                                .bold()
                            Text(viewModel.selectedDate.formatted(date: .long, time: .omitted))
                                .dynaPuffFont(size: 14)
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.getWeekDays(), id: \.self) { date in
                                Button {
                                    withAnimation { viewModel.selectedDate = date }
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(date.formatted(.dateTime.month(.abbreviated)))
                                            .font(.system(size: 10))
                                        Text(date.formatted(.dateTime.day()))
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .frame(width: 48, height: 64)
                                    .background(Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate) ? Color.daynestAccent : Color.white.opacity(0.3))
                                    .foregroundStyle(Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate) ? .white : .black)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("To Do")
                            .dynaPuffFont(size: 22)
                            .bold()
                        
                        ScrollView {
                            LazyVStack(spacing: 6) {
                                ForEach(filteredItems) { item in
                                    TaskRow(item: item)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                viewModel.deleteItem(item)
                                            } label: {
                                                Label("Delete Task", systemImage: "trash")
                                            }
                                        }
                                }
                                
                                Button {
                                    viewModel.addNewItem()
                                } label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add new task...")
                                    }
                                    .dynaPuffFont(size: 16)
                                    .foregroundStyle(.daynestAccent)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .offset(x: 10)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
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
}



