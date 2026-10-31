# Windgate roadmap

> Priority tier 1 (2026-10-17): live blocker, work first. Order: live blockers, ship pushes, active features, portfolio, exploratory. See ~/Documents/Code/LOOP-HANDOFF.md.

## Native fleet
- [ ] kmp/ module for Android + Windows/Linux desktop if that coverage matters later

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)

## Ingested 2026-10-16
- [ ] Airwell iOS 1.0 is REJECTED (macOS 1.0 is READY_FOR_DISTRIBUTION, live). Rejection reason unread: `asc web review show --app 6810806058` hit Apple sign-in 503 on 2026-10-26 (asc paused until 12:20Z). Needs Joshua to run `asc web auth login --apple-id trommatic@icloud.com`, then read the reason and reply or fix. Earlier 4.3/4.2.6 reply (2026-10-05) said the build is the native SwiftUI rewrite; do not resubmit a web view.
