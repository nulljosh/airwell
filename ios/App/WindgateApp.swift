import SwiftUI

@main
struct WindgateApp: App {
    @StateObject private var library = Library()
    @StateObject private var runner = Runner()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(library)
                .environmentObject(runner)
                .preferredColorScheme(.dark)
        }
        #if os(macOS)
        .defaultSize(width: 480, height: 760)
        #endif
    }
}

enum Theme {
    static let background = Color(red: 0.043, green: 0.078, blue: 0.125)
    static let breath = Color(red: 0.78, green: 0.88, blue: 0.95)
    static let accent = Color(red: 0.71, green: 0.31, blue: 0.17)
}

struct RootView: View {
    @EnvironmentObject var library: Library
    @EnvironmentObject var runner: Runner

    var body: some View {
        TabView {
            Tab("Breathe", systemImage: "wind") { BreatheView() }
            Tab("Patterns", systemImage: "waveform.path") { PatternsView() }
            Tab("Progress", systemImage: "flame") { ProgressTab() }
            Tab("Settings", systemImage: "gearshape") { SettingsView() }
        }
        .tint(Theme.breath)
        .onAppear {
            runner.onPhase = { [library] phase in if library.haptics { Haptics.pulse(phase) } }
            runner.onEnd = { [library] name, seconds, done in
                library.record(pattern: name, seconds: seconds)
                if done && library.haptics { Haptics.done() }
            }
        }
    }
}
