# Breathe
v1.0.0

Guided breathing, `breathe.heyitsmejosh.com`. One static page: four presets (Box, 4-7-8, Relax, Coherent) driving a CSS-transitioned circle. No backend, no build step.

## Stack
- `web/index.html`: everything. Inline CSS, inline JS. Phase timings live in the `pattern` array (inhale, hold, exhale, hold in seconds; 0 skips a phase).
- Cloudflare Worker, static assets only (`[assets] directory = "web"` in `wrangler.toml`), no worker.js — deploy is `npx wrangler deploy`.

## Structure
- `web/index.html`: landing page + breathing tool, single file
- `ios/App/BreatheApp.swift`: everything. WKWebView loading breathe.heyitsmejosh.com directly, no re-implemented UI (like lucarne). One xcodegen target, iOS + macOS.

## Deploy
```bash
npx wrangler deploy
```

## Build (native)
```bash
cd ios && xcodegen generate
xcodebuild build -project Breathe.xcodeproj -scheme Breathe -destination 'platform=macOS'
xcodebuild build -project Breathe.xcodeproj -scheme Breathe -destination 'generic/platform=iOS Simulator'
```

## App Store
Bundle com.nulljosh.breathe (SK644396X9). No ASC app record yet — creation needs the web UI (asc-app-create-ui), blocked on Chrome extension connectivity as of 2026-09-10.
