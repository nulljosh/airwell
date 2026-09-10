# Breathe roadmap

## Native fleet
- [x] ios/: SwiftUI + WKWebView wrapper (iOS + macOS), like lucarne — wraps breathe.heyitsmejosh.com, no reimplementation
- [ ] kmp/ module for Android + Windows/Linux desktop if that coverage matters later

## App Store — BLOCKED on Chrome extension
- [x] Bundle ID registered: com.nulljosh.breathe (SK644396X9)
- [ ] ASC app record — needs `asc-app-create-ui` (Chrome extension not connected 2026-09-10, retry when it is). Name "Breathe" had no exact match in public search; try it first, fallback: Breathr, Breathe App, Coherent Breathing
- [ ] Screenshots via asc-shots-pipeline
- [ ] Signing via asc-signing-setup, archive/upload via asc-xcode-build, submit via asc-release-flow

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)
- [ ] native (kmp) port — sibling apps have one, this doesn't (project-sync 2026-09-05)
