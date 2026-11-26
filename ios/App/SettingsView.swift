import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var library: Library
    @Environment(\.palette) private var palette

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 52), spacing: 12)], spacing: 12) {
                        ForEach(Palette.presets + [library.customTheme]) { swatch($0) }
                    }
                    .padding(.vertical, 4)
                    if library.themeID == "custom" {
                        picker("Background", \.background)
                        picker("Circle", \.breath)
                        picker("Button", \.accent)
                    }
                } header: {
                    Text("Theme")
                } footer: {
                    if library.themeID == "custom" { Text("Text colours adjust themselves so everything stays readable.") }
                }
                Section {
                    Toggle("Haptics", isOn: $library.haptics)
                } footer: {
                    Text("A tap at each change of breath. Works on iPhone and Mac trackpads.")
                }
                Section {
                    Toggle("Daily reminder", isOn: $library.reminderOn)
                    if library.reminderOn {
                        DatePicker("Time", selection: $library.reminderTime, displayedComponents: .hourAndMinute)
                    }
                } footer: {
                    if library.reminderDenied { Text("Notifications are off for Airwell. Turn them on in system Settings.") }
                }
                Section {
                    Link("Support", destination: URL(string: "https://airwell.jaybulb.com")!)
                } footer: {
                    Text("Your patterns and history stay on this device.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(palette.background.color)
            .navigationTitle("Settings")
            .animation(.smooth, value: library.themeID)
            .sensoryFeedback(trigger: library.themeID) { _, _ in library.haptics ? .selection : nil }
            .sensoryFeedback(trigger: library.haptics) { _, on in on ? .success : nil }
        }
    }

    private func swatch(_ p: Palette) -> some View {
        let picked = library.themeID == p.id
        return Button { library.themeID = p.id } label: {
            ZStack {
                Circle().fill(p.background.color)
                Circle().fill(p.breath.color).scaleEffect(0.55)
                Circle().fill(p.accent.color).frame(width: 12, height: 12).offset(x: 13, y: 13)
                if p.id == "custom" { Image(systemName: "paintpalette.fill").font(.footnote).foregroundStyle(p.breath.ink.color) }
            }
            .frame(width: 48, height: 48)
            .overlay(Circle().strokeBorder(Color.primary.opacity(0.25), lineWidth: 1))
            .padding(3)
            .overlay(Circle().strokeBorder(palette.breath.color, lineWidth: picked ? 3 : 0))
            .frame(minWidth: 52, minHeight: 52)
            .scaleEffect(picked ? 1.06 : 1)
            .animation(.snappy, value: picked)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(L(p.name))
        .accessibilityAddTraits(picked ? .isSelected : [])
    }

    private func picker(_ title: LocalizedStringKey, _ key: WritableKeyPath<Palette, RGB>) -> some View {
        ColorPicker(title, selection: Binding(
            get: { library.customTheme[keyPath: key].color },
            set: { library.customTheme[keyPath: key] = RGB($0) }
        ), supportsOpacity: false)
    }
}
