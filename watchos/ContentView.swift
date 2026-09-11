import SwiftUI
import WatchKit

private let presets: [(name: String, pattern: [Int])] = [
    ("Box", [4, 4, 4, 4]),
    ("4-7-8", [4, 7, 8, 0]),
    ("Relax", [4, 0, 6, 0]),
    ("Coherent", [5, 0, 5, 0]),
]

private let phaseLabels = ["Inhale", "Hold", "Exhale", "Hold"]

struct ContentView: View {
    @State private var patternIndex = 0
    @State private var running = false
    @State private var phase = 0
    @State private var scale: CGFloat = 0.5
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 8) {
            if running {
                Circle()
                    .fill(.cyan.opacity(0.35))
                    .overlay(Circle().stroke(.cyan, lineWidth: 2))
                    .scaleEffect(scale)
                    .frame(width: 90, height: 90)
                Text(phaseLabels[phase])
                    .font(.headline)
                Button("Stop") { stop() }
                    .tint(.red)
            } else {
                Picker("Pattern", selection: $patternIndex) {
                    ForEach(presets.indices, id: \.self) { i in
                        Text(presets[i].name).tag(i)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 60)
                Button("Start") { start() }
                    .tint(.cyan)
            }
        }
        .onDisappear { stop() }
    }

    private func start() {
        running = true
        phase = -1
        advance()
    }

    private func stop() {
        running = false
        timer?.invalidate()
        timer = nil
    }

    private func advance() {
        let pattern = presets[patternIndex].pattern
        var next = phase
        var duration = 0
        repeat {
            next = (next + 1) % pattern.count
            duration = pattern[next]
        } while duration == 0

        phase = next
        WKInterfaceDevice.current().play(phase == 0 ? .start : (phase == 2 ? .stop : .click))

        withAnimation(.easeInOut(duration: Double(duration))) {
            scale = phase == 0 ? 1.0 : (phase == 2 ? 0.5 : scale)
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Double(duration), repeats: false) { _ in
            if running { advance() }
        }
    }
}
