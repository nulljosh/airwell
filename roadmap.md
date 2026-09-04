# Breathe roadmap

## Repo standard (nimble reference)
- [x] README.md with icon.svg, badges, live link, Features
- [x] LICENSE (MIT), SECURITY.md, CLAUDE.md, WHITEPAPER.md, architecture.svg, icon.svg

## Product
- [x] Custom pattern builder + rep counter
- [x] Sound cue (soft chime on phase change), optional and off by default
- [x] Remember last-used preset and sound setting (localStorage)
- [x] Keyboard/space-bar toggle for start/stop

## Native fleet (KMP, like nimble/kmp, homeward/kmp)
- [ ] kmp/ module: iOS + macOS + Android + Windows/Linux desktop
- [ ] Same breathing engine (phase timings) ported, not reimplemented per platform

## App Store
- [ ] Name check via asc-name-creator, ASC app record
- [ ] Screenshots via asc-shots-pipeline once native build exists

## Infra
- [ ] /api + /mcp if a backend feature ever needs one (none does yet — skip until it does)
