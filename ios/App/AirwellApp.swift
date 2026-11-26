import SwiftUI

@main
struct AirwellApp: App {
    @StateObject private var library = Library()
    @StateObject private var runner = Runner()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(library)
                .environmentObject(runner)
                .environment(\.palette, library.palette)
                .preferredColorScheme(library.palette.isDark ? .dark : .light)
        }
        #if os(macOS)
        .defaultSize(width: 480, height: 760)
        #endif
    }
}

struct RootView: View {
    @EnvironmentObject var library: Library
    @EnvironmentObject var runner: Runner
    @Environment(\.palette) private var palette
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false

    var body: some View {
        ZStack {
            TabView {
                Tab("Breathe", systemImage: "wind") { BreatheView() }
                Tab("Patterns", systemImage: "waveform.path") { PatternsView() }
                Tab("Progress", systemImage: "flame") { ProgressTab() }
                Tab("Settings", systemImage: "gearshape") { SettingsView() }
            }
            .tint(palette.breath.color)
            if !hasSeenWelcome {
                WelcomeView { withAnimation(.smooth) { hasSeenWelcome = true } }
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.smooth, value: library.themeID)
        .onAppear {
            runner.onPhase = { [library] phase in
                AccessibilityNotification.Announcement(phase.label).post()
                if library.haptics { Haptics.pulse(phase) }
            }
            runner.onEnd = { [library] name, seconds, done in
                library.record(pattern: name, seconds: seconds)
                if done && library.haptics { Haptics.done() }
            }
        }
    }
}

/// First launch only: the Stocks-style welcome. One screen, one button.
struct WelcomeView: View {
    @Environment(\.palette) private var palette
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            palette.background.color.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 48) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Welcome to").foregroundStyle(palette.accent.color)
                            Text("Airwell")
                        }
                        .font(.largeTitle.bold())
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isHeader)
                        VStack(alignment: .leading, spacing: 32) {
                            row("wind", "Guided patterns", "Box, 4-7-8, Relax and Coherent, or make your own.")
                            row("hand.tap", "Feel each breath", "A soft tap marks every change, so your eyes can rest.")
                            row("flame", "Keep a streak", "Sessions are logged so you can watch the days add up.")
                        }
                    }
                    .padding(.top, 96)
                    .frame(maxWidth: 520, alignment: .leading)
                }
                .scrollBounceBehavior(.basedOnSize)
                Label("Everything stays on this device. No account, no tracking.", systemImage: "lock.fill")
                    .font(.footnote).foregroundStyle(.secondary)
                    .padding(.vertical, 16)
                Button(action: onContinue) {
                    Text("Continue").font(.headline).frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundStyle(palette.accent.ink.color)
                }
                .buttonStyle(.borderedProminent).buttonBorderShape(.capsule)
                .tint(palette.accent.color)
                .padding(.bottom, 8)
                .frame(maxWidth: 520)
            }
            .padding(.horizontal, 32)
        }
    }

    private func row(_ symbol: String, _ title: LocalizedStringKey, _ body: LocalizedStringKey) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: symbol).font(.title).foregroundStyle(palette.accent.color).frame(width: 44)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(body).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
