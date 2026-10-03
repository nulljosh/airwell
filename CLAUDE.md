# Windgate
v1.0 (native rewrite, resubmitted 2026-10-03; ASC version string stays 1.0, bump the build number)

Guided breathing, `windgate.heyitsmejosh.com`. One static page: four presets (Box, 4-7-8, Relax, Coherent) driving a CSS-transitioned circle. No backend, no build step.

## Stack
- `web/index.html`: everything. Inline CSS, inline JS. Phase timings live in the `pattern` array (inhale, hold, exhale, hold in seconds; 0 skips a phase).
- Cloudflare Worker, static assets only (`[assets] directory = "web"` in `wrangler.toml`), no worker.js — deploy is `npx wrangler deploy`.

## Structure
- `web/index.html`: landing page + breathing tool, single file
- `ios/App/`: the native app (iOS + macOS, one xcodegen target, no web view). `Pattern.swift` (phase math, presets), `Library.swift` (custom patterns, history, streak, reminder, JSON in Application Support), `Runner.swift` (session timer, haptics), `BreatheView`, `PatternsView`, `ProgressTab`, `SettingsView`.
- Apple rejected 1.0 under 4.3(a) because the app was a web view. The native rewrite is the fix. Never go back to a web view.

## Deploy
```bash
npx wrangler deploy
```

## Build (native)
```bash
cd ios && xcodegen generate
xcodebuild build -project Windgate.xcodeproj -scheme Windgate -destination 'platform=macOS'
xcodebuild build -project Windgate.xcodeproj -scheme Windgate -destination 'generic/platform=iOS Simulator'
```

## App Store
Bundle com.nulljosh.breathe (SK644396X9). ASC record 6810806058, listed as **Windgate** — "Breathe" and every other single-word candidate were taken. Repo, domain, on-page copy, and the Xcode target itself are all renamed to Windgate (2026-09-10); only the bundle ID still says "breathe" (renaming it would mean a new ASC bundle ID + app record — not worth it).
