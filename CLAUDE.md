# Breathe
v1.0.0

Guided breathing, `breathe.heyitsmejosh.com`. One static page: four presets (Box, 4-7-8, Relax, Coherent) driving a CSS-transitioned circle. No backend, no build step.

## Stack
- `web/index.html`: everything. Inline CSS, inline JS. Phase timings live in the `pattern` array (inhale, hold, exhale, hold in seconds; 0 skips a phase).
- Cloudflare Worker, static assets only (`[assets] directory = "web"` in `wrangler.toml`), no worker.js — deploy is `npx wrangler deploy`.

## Structure
- `web/index.html`: landing page + breathing tool, single file

## Deploy
```bash
npx wrangler deploy
```
