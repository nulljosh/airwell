import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var library: Library

    var body: some View {
        NavigationStack {
            Form {
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
                    if library.reminderDenied { Text("Notifications are off for Windgate. Turn them on in system Settings.") }
                }
                Section {
                    Link("Support", destination: URL(string: "https://windgate.heyitsmejosh.com")!)
                } footer: {
                    Text("Your patterns and history stay on this device.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Settings")
        }
    }
}
