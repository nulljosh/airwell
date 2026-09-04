# Breathe Technical Whitepaper

**v1.0.0** | September 2026

A guided breathing tool. Pick a pattern, watch a circle expand and contract,
breathe with it. Live at [breathe.heyitsmejosh.com](https://breathe.heyitsmejosh.com).

## The mechanic

Every breathing pattern is four numbers: inhale, hold, exhale, hold, each in
seconds. A CSS transition on the circle's `transform: scale()` is set to the
current phase's duration, so the circle's motion *is* the timer, there's no
separate countdown to watch. When a phase finishes, a `setTimeout` matching
that duration advances to the next one and loops. A phase of `0` seconds is
skipped (used by patterns like 4-7-8, which has no second hold).

Four presets ship: Box (4-4-4-4), 4-7-8, Relax (4-0-6-0), Coherent (5-0-5-0).
Switching presets mid-session restarts from the inhale phase of the new
pattern rather than mid-cycle.

## Design

Dark by default, light on `prefers-color-scheme: light`. One accent color,
one shape, no imagery. The point is to look at less, not more.

## Security / Privacy

No backend, no accounts, no analytics, no storage beyond the browser tab.
Nothing is collected because nothing needs to be.

## License

MIT 2026, Joshua Trommel
