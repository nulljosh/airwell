import SwiftUI

struct PatternsView: View {
    @EnvironmentObject var library: Library
    @State private var editing: Pattern?

    var body: some View {
        NavigationStack {
            List {
                Section("Built in") { ForEach(Pattern.presets) { row($0) } }
                Section("Yours") {
                    if library.custom.isEmpty {
                        Text("Make your own rhythm with the + button.").foregroundStyle(.secondary)
                    }
                    ForEach(library.custom) { p in
                        row(p)
                            .swipeActions {
                                Button("Delete", role: .destructive) { library.delete(p) }
                                Button("Edit") { editing = p }.tint(.gray)
                            }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Patterns")
            .toolbar {
                Button("New pattern", systemImage: "plus") {
                    editing = Pattern(name: "", inhale: 4, holdIn: 0, exhale: 6, holdOut: 0, isCustom: true)
                }
            }
            .sheet(item: $editing) { PatternEditor(pattern: $0) }
        }
    }

    private func row(_ p: Pattern) -> some View {
        Button {
            library.selectedID = p.id
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(p.name).foregroundStyle(.primary)
                    Text(p.summary).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                if library.selectedID == p.id { Image(systemName: "checkmark").foregroundStyle(Theme.breath) }
            }
        }
        .accessibilityAddTraits(library.selectedID == p.id ? .isSelected : [])
    }
}

struct PatternEditor: View {
    @EnvironmentObject var library: Library
    @Environment(\.dismiss) private var dismiss
    @State var pattern: Pattern

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $pattern.name)
                stepper("Breathe in", $pattern.inhale, min: 1)
                stepper("Hold", $pattern.holdIn, min: 0)
                stepper("Breathe out", $pattern.exhale, min: 1)
                stepper("Hold", $pattern.holdOut, min: 0)
                Text("One breath takes \(pattern.cycle.formatted()) seconds.").foregroundStyle(.secondary)
            }
            .navigationTitle(pattern.name.isEmpty ? "New pattern" : pattern.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        library.upsert(pattern)
                        library.selectedID = pattern.id
                        dismiss()
                    }
                    .disabled(!pattern.isValid)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func stepper(_ title: String, _ value: Binding<Double>, min: Double) -> some View {
        Stepper(value: value, in: min...12, step: 0.5) {
            HStack { Text(title); Spacer(); Text("\(value.wrappedValue.formatted()) s").foregroundStyle(.secondary) }
        }
    }
}
