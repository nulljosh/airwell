# Architecture

Guided breathing tool. Four presets (Box, 4-7-8, Relax, Coherent) and a customizable pattern drive a CSS-animated circle that expands and contracts to guide your breath. No backend, no accounts, no analytics. Web app deployed to `windgate.heyitsmejosh.com`, with native iOS and macOS wrappers and watchOS support.

## How it runs

On the web, `web/index.html` renders an interactive breathing interface. Users select a preset pattern or create a custom one (four numbers: inhale, hold, exhale, hold in seconds). Clicking Start begins the cycle. A CSS `transform: scale()` transition animates the circle over the phase duration, so the circle's motion is the timer itself. When a phase ends, JavaScript's `setTimeout` matching that duration fires, plays an optional chime, and advances to the next phase. A phase of 0 seconds is skipped (e.g., 4-7-8 has no second hold). On iOS and macOS, `AirwellApp.swift` wraps the web page in a WKWebView, passing `?embed` in the URL to hide the landing chrome. watchOS loads a separate experience from `watchos/`.

| File | What it owns |
|---|---|
| `web/index.html` | Complete breathing tool: landing page, preset buttons, animated circle, start/stop control, sound toggle, custom pattern input. Inline CSS (dark by default, light mode support). Inline JavaScript: pattern selection, phase timing via setTimeout, CSS transitions, optional chime audio via Web Audio API, localStorage persistence (sound and preset state). Device-aware demo frame (shows the app live in a frame matched to iPhone/Android/Mac/Windows). |
| `web/devices.css` | Device frame styling (the nimble treatment: mobile phones and desktop windows). |
| `web/privacy.html` | Privacy policy (no data collection). |
| `ios/App/AirwellApp.swift` | SwiftUI app entry point and content view. Defines `breatheURL` (web app with `?embed` flag). Wraps WKWebView in both iOS and macOS variants. Shows loading spinner, retry button on failure. |
| `ios/App/AirwellTests.swift` | Unit tests. |
| `ios/project.yml` | xcodegen project definition for iOS and macOS targets. |
| `ios/Airwell.entitlements` + `ios/Airwell-macOS.entitlements` | App sandboxing and capabilities (network access for web loading). |
| `watchos/` | watchOS app (separate experience, not a web wrapper). Contains `AirwellWatchApp.swift` and `ContentView.swift`. |
| `wrangler.toml` | Cloudflare Worker config. Static asset serving only, no worker.js. Assets live in `web/`. |
| `test.mjs` | JavaScript test (pattern validation). |
