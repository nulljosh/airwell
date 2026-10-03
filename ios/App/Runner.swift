import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

enum Haptics {
    static func pulse(_ phase: Phase) {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: phase == .inhale ? .soft : .light).impactOccurred()
        #else
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
        #endif
    }

    static func done() {
        #if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #else
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)
        #endif
    }
}

/// Drives one session: a timer feeds `tick`, phase changes fire `onPhase`, the end fires `onEnd`.
@MainActor
final class Runner: ObservableObject {
    @Published private(set) var tick: Tick?
    @Published private(set) var left: Double = 0
    private(set) var pattern: Pattern?
    private var total: Double = 0
    private var start: Date?
    private var timer: Timer?
    private var lastPhase: Phase?

    var onPhase: ((Phase) -> Void)?
    /// Pattern name, seconds breathed, whether the timer ran out.
    var onEnd: ((String, Int, Bool) -> Void)?

    var running: Bool { start != nil }

    func begin(_ pattern: Pattern, minutes: Int, now: Date = .now) {
        self.pattern = pattern
        total = Double(minutes * 60)
        start = now
        lastPhase = nil
        step(now: now)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.step(now: .now) }
        }
    }

    func step(now: Date) {
        guard let start, let pattern else { return }
        let t = now.timeIntervalSince(start)
        if t >= total { return finish(seconds: Int(total), done: true) }
        let tick = pattern.tick(at: t)
        if tick.phase != lastPhase { lastPhase = tick.phase; onPhase?(tick.phase) }
        self.tick = tick
        left = total - t
    }

    func stop(now: Date = .now) {
        guard let start else { return }
        finish(seconds: Int(now.timeIntervalSince(start)), done: false)
    }

    private func finish(seconds: Int, done: Bool) {
        let name = pattern?.name ?? ""
        timer?.invalidate()
        timer = nil
        start = nil
        tick = nil
        onEnd?(name, seconds, done)
    }
}
