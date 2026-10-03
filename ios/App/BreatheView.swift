import SwiftUI

struct BreatheView: View {
    @EnvironmentObject var library: Library
    @EnvironmentObject var runner: Runner

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 28) {
                header
                Spacer(minLength: 0)
                circle
                Spacer(minLength: 0)
                controls
            }
            .padding(24)
            .frame(maxWidth: 560)
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Menu {
                Picker("Pattern", selection: $library.selectedID) {
                    ForEach(library.all) { Text($0.name).tag($0.id) }
                }
            } label: {
                Label(library.selected.name, systemImage: "chevron.up.chevron.down")
                    .labelStyle(.titleAndIcon)
                    .font(.title3.weight(.semibold))
            }
            .disabled(runner.running)
            Text(library.selected.summary).font(.subheadline).foregroundStyle(.secondary)
        }
    }

    private var circle: some View {
        let tick = runner.tick
        return ZStack {
            Circle().stroke(Theme.breath.opacity(0.15), lineWidth: 2)
            Circle().fill(Theme.breath.opacity(0.9)).scaleEffect(tick?.scale ?? Pattern.low)
            if let tick {
                VStack(spacing: 2) {
                    Text(tick.phase.label).font(.title2.weight(.semibold))
                    Text("\(Int(tick.remaining.rounded(.up)))").font(.largeTitle.weight(.bold)).monospacedDigit()
                }
                .foregroundStyle(Theme.background)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel(tick?.phase.label ?? "Breathing circle")
        .accessibilityValue(tick.map { "\(Int($0.remaining.rounded(.up))) seconds" } ?? "Not started")
    }

    private var controls: some View {
        VStack(spacing: 16) {
            if runner.running {
                Text(timeLeft).font(.headline).monospacedDigit().foregroundStyle(.secondary)
                Button("End") { runner.stop() }
                    .buttonStyle(.bordered).controlSize(.large)
            } else {
                Picker("Length", selection: $library.minutes) {
                    ForEach([1, 3, 5, 10], id: \.self) { Text("\($0) min").tag($0) }
                }
                .pickerStyle(.segmented)
                Button {
                    runner.begin(library.selected, minutes: library.minutes)
                } label: {
                    Text("Begin").font(.headline).frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(Theme.accent).controlSize(.large)
            }
        }
    }

    private var timeLeft: String {
        let s = Int(runner.left.rounded(.up))
        return String(format: "%d:%02d left", s / 60, s % 60)
    }
}
