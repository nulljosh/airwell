# Breathe roadmap

## Repo standard (nimble reference)
- [ ] README.md with icon.svg, badges, live link, Features
- [ ] LICENSE (MIT), SECURITY.md, CLAUDE.md, WHITEPAPER.md, architecture.svg, icon.svg
- [ ] icon.svg 200x200 dark terminal aesthetic

## Product
- [ ] More patterns: 4-4-4-4 labeled, custom pattern builder, session length / rep counter
- [ ] Sound cue (soft chime on phase change), optional and off by default
- [ ] Remember last-used preset (localStorage)
- [ ] Keyboard/space-bar toggle for start/stop

## Native fleet (KMP, like nimble/kmp, homeward/kmp)
- [ ] kmp/ module: iOS + macOS + Android + Windows/Linux desktop
- [ ] Same breathing engine (phase timings) ported, not reimplemented per platform

## App Store
- [ ] Name check via asc-name-creator, ASC app record
- [ ] Screenshots via asc-shots-pipeline once native build exists

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)
