import Foundation

final class TaskStorage {
    static let shared = TaskStorage()

    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(directory: URL? = nil) {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let dir = directory ?? home.appendingPathComponent("Documents/ToDoApp", isDirectory: true)
        fileURL = dir.appendingPathComponent("tasks.json")

        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd"

        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .formatted(df)

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(df)
    }

    func load() -> [TaskItem] {
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                return []
            }
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([TaskItem].self, from: data)
        } catch {
            return []
        }
    }

    func save(_ tasks: [TaskItem]) {
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            let data = try encoder.encode(tasks)
            let tmp = fileURL.appendingPathExtension("tmp")
            try data.write(to: tmp, options: .atomic)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try? FileManager.default.removeItem(at: fileURL)
            }
            try FileManager.default.moveItem(at: tmp, to: fileURL)
        } catch {
        }
    }
}

