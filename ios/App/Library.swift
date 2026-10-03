import Foundation
import UserNotifications

struct Record: Codable, Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var pattern: String
    var seconds: Int
}

/// Custom patterns, session history and settings. Everything lives on the device.
@MainActor
final class Library: ObservableObject {
    private let file: URL
    private let defaults: UserDefaults

    @Published private(set) var custom: [Pattern] = []
    @Published private(set) var records: [Record] = []
    @Published var selectedID: UUID { didSet { defaults.set(selectedID.uuidString, forKey: "selected") } }
    @Published var minutes: Int { didSet { defaults.set(minutes, forKey: "minutes") } }
    @Published var haptics: Bool { didSet { defaults.set(haptics, forKey: "haptics") } }
    @Published var reminderOn: Bool { didSet { defaults.set(reminderOn, forKey: "reminderOn"); syncReminder() } }
    @Published var reminderTime: Date { didSet { defaults.set(reminderTime, forKey: "reminderTime"); syncReminder() } }
    @Published var reminderDenied = false

    nonisolated static var defaultFile: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("windgate.json")
    }

    init(file: URL = Library.defaultFile, defaults: UserDefaults = .standard) {
        self.file = file
        self.defaults = defaults
        selectedID = UUID(uuidString: defaults.string(forKey: "selected") ?? "") ?? Pattern.presets[0].id
        minutes = defaults.object(forKey: "minutes") as? Int ?? 3
        haptics = defaults.object(forKey: "haptics") as? Bool ?? true
        reminderOn = defaults.bool(forKey: "reminderOn")
        reminderTime = defaults.object(forKey: "reminderTime") as? Date
            ?? Calendar.current.date(from: DateComponents(hour: 20, minute: 0))!
        if let data = try? Data(contentsOf: file), let saved = try? JSONDecoder().decode(Saved.self, from: data) {
            custom = saved.custom
            records = saved.records
        }
    }

    private struct Saved: Codable { var custom: [Pattern]; var records: [Record] }

    private func save() {
        try? JSONEncoder().encode(Saved(custom: custom, records: records)).write(to: file, options: .atomic)
    }

    // MARK: patterns

    var all: [Pattern] { Pattern.presets + custom }
    var selected: Pattern { all.first { $0.id == selectedID } ?? Pattern.presets[0] }

    func upsert(_ pattern: Pattern) {
        var p = pattern
        p.isCustom = true
        p.name = p.name.trimmingCharacters(in: .whitespaces)
        if let i = custom.firstIndex(where: { $0.id == p.id }) { custom[i] = p } else { custom.append(p) }
        save()
    }

    func delete(_ pattern: Pattern) {
        custom.removeAll { $0.id == pattern.id }
        if selectedID == pattern.id { selectedID = Pattern.presets[0].id }
        save()
    }

    // MARK: history

    func record(pattern: String, seconds: Int, date: Date = .now) {
        guard seconds >= 15 else { return }
        records.insert(Record(date: date, pattern: pattern, seconds: seconds), at: 0)
        save()
    }

    func remove(_ record: Record) {
        records.removeAll { $0.id == record.id }
        save()
    }

    /// Days in a row with at least one session. Today not yet done does not break a streak.
    func streak(now: Date = .now, calendar: Calendar = .current) -> Int {
        let days = Set(records.map { calendar.startOfDay(for: $0.date) })
        var day = calendar.startOfDay(for: now)
        if !days.contains(day) { day = calendar.date(byAdding: .day, value: -1, to: day)! }
        var n = 0
        while days.contains(day) {
            n += 1
            day = calendar.date(byAdding: .day, value: -1, to: day)!
        }
        return n
    }

    func minutesThisWeek(now: Date = .now, calendar: Calendar = .current) -> Int {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: now) else { return 0 }
        return records.filter { week.contains($0.date) }.reduce(0) { $0 + $1.seconds } / 60
    }

    // MARK: reminder

    private func syncReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily"])
        guard reminderOn else { return }
        let time = reminderTime
        Task {
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
            guard granted else {
                reminderDenied = true
                reminderOn = false
                return
            }
            reminderDenied = false
            let content = UNMutableNotificationContent()
            content.title = "Time to breathe"
            content.body = "A few minutes is enough."
            let parts = Calendar.current.dateComponents([.hour, .minute], from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: true)
            try? await center.add(UNNotificationRequest(identifier: "daily", content: content, trigger: trigger))
        }
    }
}
