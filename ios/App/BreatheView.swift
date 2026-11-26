import SwiftUI

struct BreatheView: View {
    @EnvironmentObject var library: Library
    @EnvironmentObject var runner: Runner
    @Environment(\.palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            palette.background.color.ignoresSafeArea()
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
        .animation(.smooth, value: runner.running)
        .sensoryFeedback(trigger: runner.running) { _, running in library.haptics && running ? .impact(weight: .medium) : nil }
        .sensoryFeedback(trigger: library.minutes) { _, _ in library.haptics ? .selection : nil }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Menu {
                Picker("Pattern", selection: $library.selectedID) {
                    ForEach(library.all) { Text($0.title).tag($0.id) }
                }
            } label: {
                Label(library.selected.title, systemImage: "chevron.up.chevron.down")
                    .labelStyle(.titleAndIcon)
                    .font(.title3.weight(.semibold))
            }
            .disabled(runner.running)
            .accessibilityHint(Text("Choose a breathing pattern"))
            Text(library.selected.summary).font(.subheadline).foregroundStyle(.secondary)
                .contentTransition(.numericText())
        }
        .animation(.smooth, value: library.selectedID)
    }

    private var circle: some View {
        let tick = runner.tick
        let scale = tick?.scale ?? Pattern.low
        let progress = (scale - Pattern.low) / (1 - Pattern.low)
        return ZStack {
            Circle().stroke(palette.breath.color.opacity(0.15), lineWidth: 2)
            // Reduce Motion: the circle holds still and the outer ring brightens and dims instead.
            Circle().stroke(palette.breath.color.opacity(reduceMotion ? 0.15 + 0.85 * progress : 0.3), lineWidth: reduceMotion ? 4 : 2)
                .scaleEffect(reduceMotion ? 1 : min(scale * 1.08, 1))
            Circle().fill(palette.breath.color.opacity(0.9))
                .scaleEffect(reduceMotion ? 0.75 : scale)
            if let tick {
                VStack(spacing: 2) {
                    Text(tick.phase.label).font(.title2.weight(.semibold))
                        .minimumScaleFactor(0.6).lineLimit(1)
                        .contentTransition(.interpolate)
                    Text(Int(tick.remaining.rounded(.up)), format: .number).font(.largeTitle.weight(.bold)).monospacedDigit()
                        .contentTransition(.numericText(countsDown: true))
                }
                .foregroundStyle(palette.onBreath.color)
                .animation(.smooth(duration: 0.25), value: tick.phase)
            } else {
                Image(systemName: "wind").font(.largeTitle).foregroundStyle(palette.onBreath.color.opacity(0.8))
                    .symbolEffect(.pulse, isActive: !reduceMotion)
                    .accessibilityHidden(true)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel(tick?.phase.label ?? String(localized: "Breathing circle"))
        .accessibilityValue(tick.map { String(localized: "\(Int($0.remaining.rounded(.up))) seconds") } ?? String(localized: "Not started"))
        .accessibilityAddTraits(.updatesFrequently)
    }

    private var controls: some View {
        VStack(spacing: 16) {
            if runner.running {
                Text(timeLeft).font(.headline).monospacedDigit().foregroundStyle(.secondary)
                    .contentTransition(.numericText(countsDown: true))
                Button("End") { runner.stop() }
                    .buttonStyle(.bordered).controlSize(.large)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                Picker("Length", selection: $library.minutes) {
                    ForEach([1, 3, 5, 10], id: \.self) { Text("\($0) min").tag($0) }
                }
                .pickerStyle(.segmented)
                Button {
                    runner.begin(library.selected, minutes: library.minutes)
                } label: {
                    Text("Begin").font(.headline).frame(maxWidth: .infinity, minHeight: 28)
                        .foregroundStyle(palette.accent.ink.color)
                }
                .buttonStyle(.borderedProminent).tint(palette.accent.color).controlSize(.large)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }

    private var timeLeft: String {
        let s = Int(runner.left.rounded(.up))
        return String(localized: "\(Duration.seconds(s).formatted(.time(pattern: .minuteSecond))) left")
    }
}
