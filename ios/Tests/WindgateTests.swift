import Testing
import Foundation
@testable import Windgate

@Test func boxCyclesThroughFourPhases() {
    let box = Pattern.presets[0]
    #expect(box.cycle == 16)
    #expect(box.tick(at: 0).phase == .inhale)
    #expect(box.tick(at: 4).phase == .holdIn)
    #expect(box.tick(at: 8).phase == .exhale)
    #expect(box.tick(at: 12).phase == .holdOut)
    #expect(box.tick(at: 16).phase == .inhale, "wraps")
}

@Test func zeroPhasesAreSkipped() {
    let relax = Pattern.presets[2]
    #expect(relax.tick(at: 4).phase == .exhale)
    #expect(relax.summary == "4 · 6")
}

@Test func circleGrowsAndShrinks() {
    let p = Pattern.presets[1]
    #expect(p.tick(at: 0).scale == Pattern.low)
    #expect(p.tick(at: 4).scale == 1)
    #expect(p.tick(at: 18.999).scale < 0.5)
    #expect(p.tick(at: 2).scale > Pattern.low)
}

@Test func validation() {
    #expect(!Pattern(name: " ", inhale: 4, holdIn: 0, exhale: 4, holdOut: 0).isValid)
    #expect(!Pattern(name: "x", inhale: 0, holdIn: 0, exhale: 4, holdOut: 0).isValid)
    #expect(Pattern(name: "x", inhale: 4, holdIn: 0, exhale: 4, holdOut: 0).isValid)
}

@MainActor
private func library(_ dir: URL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")) -> Library {
    Library(file: dir, defaults: UserDefaults(suiteName: UUID().uuidString)!)
}

@MainActor @Test func customPatternsPersistAndDelete() {
    let file = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")
    let lib = library(file)
    let p = Pattern(name: " Mine ", inhale: 3, holdIn: 1, exhale: 5, holdOut: 0)
    lib.upsert(p)
    lib.selectedID = p.id
    #expect(Library(file: file, defaults: UserDefaults(suiteName: UUID().uuidString)!).custom.first?.name == "Mine")
    lib.delete(p)
    #expect(lib.custom.isEmpty)
    #expect(lib.selected.id == Pattern.presets[0].id, "falls back to a preset")
}

@MainActor @Test func streakCountsConsecutiveDays() {
    let lib = library()
    let cal = Calendar.current
    let now = Date()
    func day(_ n: Int) -> Date { cal.date(byAdding: .day, value: -n, to: now)! }
    #expect(lib.streak(now: now) == 0)
    lib.record(pattern: "Box", seconds: 60, date: day(1))
    #expect(lib.streak(now: now) == 1, "yesterday keeps it alive")
    lib.record(pattern: "Box", seconds: 60, date: day(0))
    lib.record(pattern: "Box", seconds: 60, date: day(2))
    lib.record(pattern: "Box", seconds: 60, date: day(4))
    #expect(lib.streak(now: now) == 3, "gap at day 3 ends it")
}

@MainActor @Test func tooShortSessionsAreNotRecorded() {
    let lib = library()
    lib.record(pattern: "Box", seconds: 5)
    #expect(lib.records.isEmpty)
}

@MainActor @Test func runnerFiresPhasesAndEnds() {
    let r = Runner()
    var phases: [Phase] = []
    var ended: (String, Int, Bool)?
    r.onPhase = { phases.append($0) }
    r.onEnd = { ended = ($0, $1, $2) }
    let t0 = Date()
    r.begin(Pattern.presets[2], minutes: 1, now: t0)
    r.step(now: t0.addingTimeInterval(5))
    #expect(phases == [.inhale, .exhale])
    r.step(now: t0.addingTimeInterval(61))
    #expect(ended?.0 == "Relax" && ended?.1 == 60 && ended?.2 == true)
    #expect(!r.running)
}

@MainActor @Test func endingEarlyReportsSecondsBreathed() {
    let r = Runner()
    var ended: (String, Int, Bool)?
    r.onEnd = { ended = ($0, $1, $2) }
    let t0 = Date()
    r.begin(Pattern.presets[0], minutes: 3, now: t0)
    r.stop(now: t0.addingTimeInterval(42))
    #expect(ended?.1 == 42 && ended?.2 == false)
}
