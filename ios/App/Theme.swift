import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Looks up a string that lives in Localizable.xcstrings by its English text.
func L(_ key: String) -> String { String(localized: String.LocalizationValue(key)) }

struct RGB: Codable, Equatable {
    var r: Double, g: Double, b: Double

    init(_ r: Double, _ g: Double, _ b: Double) { (self.r, self.g, self.b) = (r, g, b) }

    init(_ color: Color) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        #if os(iOS)
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        (NSColor(color).usingColorSpace(.sRGB) ?? .black).getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        let c = { (x: CGFloat) in min(max(Double(x), 0), 1) }
        self.init(c(r), c(g), c(b))
    }

    var color: Color { Color(.sRGB, red: r, green: g, blue: b) }

    /// WCAG relative luminance.
    var luminance: Double {
        func f(_ c: Double) -> Double { c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4) }
        return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)
    }

    func contrast(with o: RGB) -> Double {
        let a = luminance + 0.05, b = o.luminance + 0.05
        return max(a, b) / min(a, b)
    }

    /// Black or white, whichever reads better on this colour.
    var ink: RGB { contrast(with: RGB(0, 0, 0)) >= contrast(with: RGB(1, 1, 1)) ? RGB(0, 0, 0) : RGB(1, 1, 1) }
}

struct Palette: Codable, Equatable, Identifiable {
    var id: String
    var name: String          // English key, shown through L()
    var background: RGB
    var breath: RGB
    var accent: RGB

    var isDark: Bool { background.luminance < 0.18 }
    /// Text drawn on the breathing circle: the background if it contrasts enough, else black or white.
    var onBreath: RGB { background.contrast(with: breath) >= 4.5 ? background : breath.ink }

    static let night  = Palette(id: "night",  name: "Night",  background: RGB(0.043, 0.078, 0.125), breath: RGB(0.78, 0.88, 0.95), accent: RGB(0.71, 0.31, 0.17))
    static let dusk   = Palette(id: "dusk",   name: "Dusk",   background: RGB(0.09, 0.07, 0.17),    breath: RGB(0.80, 0.74, 0.95), accent: RGB(0.55, 0.30, 0.75))
    static let forest = Palette(id: "forest", name: "Forest", background: RGB(0.05, 0.11, 0.09),    breath: RGB(0.74, 0.90, 0.80), accent: RGB(0.20, 0.50, 0.34))
    static let ember  = Palette(id: "ember",  name: "Ember",  background: RGB(0.13, 0.07, 0.06),    breath: RGB(0.97, 0.82, 0.70), accent: RGB(0.75, 0.30, 0.13))
    static let paper  = Palette(id: "paper",  name: "Paper",  background: RGB(0.96, 0.95, 0.92),    breath: RGB(0.22, 0.36, 0.50), accent: RGB(0.62, 0.26, 0.13))
    static let presets = [night, dusk, forest, ember, paper]

    static func custom(from base: Palette = .night) -> Palette {
        Palette(id: "custom", name: "Custom", background: base.background, breath: base.breath, accent: base.accent)
    }
}

private struct PaletteKey: EnvironmentKey { static let defaultValue = Palette.night }
extension EnvironmentValues {
    var palette: Palette {
        get { self[PaletteKey.self] }
        set { self[PaletteKey.self] = newValue }
    }
}
