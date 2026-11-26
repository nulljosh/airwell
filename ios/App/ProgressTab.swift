import SwiftUI

struct ProgressTab: View {
    @EnvironmentObject var library: Library
    @Environment(\.palette) private var palette
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        NavigationStack {
            List {
                Section {
                    stats
                    .listRowBackground(Color.clear)
                }
                Section("History") {
                    if library.records.isEmpty {
                        Text("No sessions yet. Your first one is a minute away.").foregroundStyle(.secondary)
                    }
                    ForEach(library.records.prefix(60)) { r in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(L(r.pattern))
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
            .background(palette.background.color)
            .navigationTitle("Progress")
        }
    }

    @ViewBuilder private var tiles: some View {
        stat(library.streak(), "day streak")
        stat(library.minutesThisWeek(), "min this week")
        stat(library.records.count, "sessions")
    }

    /// Big text: stack the tiles so labels never break mid-word.
    @ViewBuilder private var stats: some View {
        if typeSize.isAccessibilitySize { VStack(spacing: 16) { tiles } } else { HStack { tiles } }
    }

    private func stat(_ value: Int, _ label: LocalizedStringKey) -> some View {
        VStack(spacing: 4) {
            Text(value, format: .number).font(.largeTitle.weight(.bold)).monospacedDigit()
                .contentTransition(.numericText())
            Text(label).font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .animation(.smooth, value: value)
        .accessibilityElement(children: .combine)
    }

    private func duration(_ s: Int) -> String {
        Duration.seconds(s).formatted(.units(allowed: [.minutes, .seconds], width: .abbreviated))
    }
}
