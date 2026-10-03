import SwiftUI

struct ProgressTab: View {
    @EnvironmentObject var library: Library

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        stat("\(library.streak())", "day streak")
                        stat("\(library.minutesThisWeek())", "min this week")
                        stat("\(library.records.count)", "sessions")
                    }
                    .listRowBackground(Color.clear)
                }
                Section("History") {
                    if library.records.isEmpty {
                        Text("No sessions yet. Your first one is a minute away.").foregroundStyle(.secondary)
                    }
                    ForEach(library.records.prefix(60)) { r in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(r.pattern)
                                Text(r.date.formatted(date: .abbreviated, time: .shortened)).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(duration(r.seconds)).foregroundStyle(.secondary).monospacedDigit()
                        }
                        .swipeActions { Button("Delete", role: .destructive) { library.remove(r) } }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Progress")
        }
    }

    private func stat(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.largeTitle.weight(.bold)).monospacedDigit()
            Text(label).font(.footnote).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private func duration(_ s: Int) -> String { s < 60 ? "\(s)s" : "\(s / 60)m \(s % 60)s" }
}
