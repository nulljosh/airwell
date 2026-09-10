# Windgate roadmap

## Native fleet
- [x] ios/: SwiftUI + WKWebView wrapper (iOS + macOS), like lucarne — wraps windgate.heyitsmejosh.com/?embed, no reimplementation
- [ ] kmp/ module for Android + Windows/Linux desktop if that coverage matters later

## App Store
- [x] Bundle ID registered: com.nulljosh.breathe (SK644396X9)
- [x] ASC app record created 2026-09-10: **Windgate**, id 6810806058 ("Breathe", "Breathr", "Exhalo", "Respiro", "Haven", "Glade", "Drift", "Stilla" all taken)
- [x] Full rename to match 2026-09-10: repo nulljosh/windgate, domain windgate.heyitsmejosh.com, on-page brand
- [x] Signing certs/profiles fetched, both platforms archived + uploaded (build VALID)
- [x] Metadata, pricing (free, all territories), availability, App Privacy (no data collected) done for iOS + macOS
- [x] Screenshots: iPhone, iPad, Mac all uploaded
- [x] Submitted for review 2026-09-10: iOS and macOS both WAITING_FOR_REVIEW

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)
- [ ] native (kmp) port for Android + desktop — sibling apps have one, this doesn't (project-sync 2026-09-05)
