import SwiftUI

struct TaskRow: View {
    @Bindable var item: Item
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Botón de Checkmark
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    item.isCompleted.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(item.isCompleted ? .clear : .black, lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(item.isCompleted ? Color.daynestAccent : .clear)
                        )
                    
                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            
            // Campo de texto editable
            TextField("Task name...", text: $item.title)
                .font(.custom("GoogleSansFlex-Regular", size: 17))
                .focused($isFocused)
                .strikethrough(item.isCompleted)
                .foregroundStyle(item.isCompleted ? .black.opacity(0.4) : .black)
                .submitLabel(.done)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .onAppear {
            if item.title == "New Task" {
                item.title = "" 
                isFocused = true
            }
        }
    }
}
