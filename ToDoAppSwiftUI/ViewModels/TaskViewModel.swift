import Foundation
import Combine

enum TaskFilter: String, CaseIterable, Identifiable {
    case all
    case active
    case completed
    var id: String { rawValue }
}

enum TaskSort: String, CaseIterable, Identifiable {
    case date
    case priority
    case status
    var id: String { rawValue }
}

final class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem]
    @Published var newTitle: String = ""
    @Published var selectedPriority: Priority = .medium
    @Published var filter: TaskFilter = .all
    @Published var sort: TaskSort = .date

    private let storage: TaskStorage
    private var cancellables: Set<AnyCancellable> = []

    init(storage: TaskStorage = .shared) {
        self.storage = storage
        self.tasks = storage.load()
        $tasks
            .dropFirst()
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { [weak self] items in
                self?.storage.save(items)
            }
            .store(in: &cancellables)
    }

    func addTask() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        let item = TaskItem(title: title, isCompleted: false, priority: selectedPriority, createdDate: Date())
        tasks.append(item)
        newTitle = ""
    }

    func toggle(_ item: TaskItem) {
        guard let idx = tasks.firstIndex(of: item) else { return }
        tasks[idx].isCompleted.toggle()
    }

    func remove(_ item: TaskItem) {
        tasks.removeAll { $0.id == item.id }
    }

    var remainingCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }

    var visibleTasks: [TaskItem] {
        var items: [TaskItem]
        switch filter {
        case .all:
            items = tasks
        case .active:
            items = tasks.filter { !$0.isCompleted }
        case .completed:
            items = tasks.filter { $0.isCompleted }
        }
        switch sort {
        case .date:
            items.sort { $0.createdDate > $1.createdDate }
        case .priority:
            func rank(_ p: Priority) -> Int {
                switch p {
                case .high: return 0
                case .medium: return 1
                case .low: return 2
                }
            }
            items.sort {
                let r0 = rank($0.priority), r1 = rank($1.priority)
                if r0 != r1 { return r0 < r1 }
                return $0.createdDate > $1.createdDate
            }
        case .status:
            func srank(_ t: TaskItem) -> Int { t.isCompleted ? 1 : 0 }
            items.sort {
                let a = srank($0), b = srank($1)
                if a != b { return a < b }
                return $0.createdDate > $1.createdDate
            }
        }
        return items
    }
}
