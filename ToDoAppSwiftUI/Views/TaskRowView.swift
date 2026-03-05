import SwiftUI

struct TaskRowView: View {
    let item: TaskItem
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundStyle(item.isCompleted ? Color.accentColor : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                Text(item.priority.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(priorityColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .foregroundStyle(priorityColor)
            }
            Spacer()
            Button(role: .destructive, action: onDelete) {
                Text("Delete")
            }
        }
        .padding(.vertical, 6)
    }

    private var priorityColor: Color {
        switch item.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(item: TaskItem(title: "Put the fries in the bag", priority: .high), onToggle: {}, onDelete: {})
            .padding()
            .frame(width: 360)
    }
}
