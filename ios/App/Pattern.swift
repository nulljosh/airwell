import Foundation

enum Phase: String {
    case inhale, holdIn, exhale, holdOut

    var label: String {
        switch self {
        case .inhale: "Breathe in"
        case .exhale: "Breathe out"
        case .holdIn, .holdOut: "Hold"
        }
    }
}

/// Where a session is inside one breath cycle.
struct Tick: Equatable {
    var phase: Phase
    var remaining: Double   // seconds left in this phase
    var scale: Double       // circle size, 0.45 (empty) to 1 (full)
}

struct Pattern: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var inhale: Double
    var holdIn: Double
    var exhale: Double
    var holdOut: Double
    var isCustom = false

    static let low = 0.45

    var cycle: Double { inhale + holdIn + exhale + holdOut }
    var isValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty && inhale > 0 && exhale > 0 }

    /// "4 · 7 · 8", zeros left out.
    var summary: String {
        let all: [Double] = [inhale, holdIn, exhale, holdOut]
        let parts: [String] = all.filter { $0 > 0 }.map { Pattern.format($0) }
        return parts.joined(separator: " · ")
    }

    static func format(_ n: Double) -> String { n == n.rounded() ? String(Int(n)) : String(n) }

    func tick(at t: Double) -> Tick {
        var t = t.truncatingRemainder(dividingBy: cycle)
        let steps: [(Phase, Double)] = [(.inhale, inhale), (.holdIn, holdIn), (.exhale, exhale), (.holdOut, holdOut)]
        for (phase, length) in steps where length > 0 {
            if t < length {
                return Tick(phase: phase, remaining: length - t, scale: Pattern.scale(phase, t / length))
            }
            t -= length
        }
        return Tick(phase: .inhale, remaining: inhale, scale: Pattern.low)
    }

    private static func scale(_ phase: Phase, _ p: Double) -> Double {
        let eased: Double = p * p * (3 - 2 * p)
        let span: Double = 1 - low
        switch phase {
        case .inhale: return low + span * eased
        case .holdIn: return 1
        case .exhale: return 1 - span * eased
        case .holdOut: return low
        }
    }

    static let presets: [Pattern] = [
        Pattern(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Box", inhale: 4, holdIn: 4, exhale: 4, holdOut: 4),
        Pattern(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "4-7-8", inhale: 4, holdIn: 7, exhale: 8, holdOut: 0),
        Pattern(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, name: "Relax", inhale: 4, holdIn: 0, exhale: 6, holdOut: 0),
        Pattern(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, name: "Coherent", inhale: 5.5, holdIn: 0, exhale: 5.5, holdOut: 0),
    ]
}
