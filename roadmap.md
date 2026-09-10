# Breathe roadmap

## Native fleet
- [x] ios/: SwiftUI + WKWebView wrapper (iOS + macOS), like lucarne — wraps breathe.heyitsmejosh.com, no reimplementation
- [ ] kmp/ module for Android + Windows/Linux desktop if that coverage matters later

## App Store
- [x] Bundle ID registered: com.nulljosh.breathe (SK644396X9)
- [x] ASC app record created 2026-09-10: **Windgate**, id 6810806058 ("Breathe", "Breathr", "Exhalo", "Respiro", "Haven", "Glade", "Drift", "Stilla" all taken). On-device display name matches (CFBundleDisplayName); repo/domain stay "breathe" (same split as charwork/Wiretext).
- [ ] Signing via asc-signing-setup
- [ ] Archive/upload via asc-xcode-build
- [ ] Screenshots via asc-shots-pipeline
- [ ] Submit via asc-release-flow / asc-submission-health

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)
- [ ] native (kmp) port — sibling apps have one, this doesn't (project-sync 2026-09-05)
