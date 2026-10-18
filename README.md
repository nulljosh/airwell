<img src="icon.svg" width="80" style="border-radius:18px">

# Airwell

![version](https://img.shields.io/badge/version-v1.0.0-blue) ![license](https://img.shields.io/badge/license-MIT-green) [![GitHub](https://img.shields.io/badge/GitHub-nulljosh%2Fwindgate-black?logo=github)](https://github.com/nulljosh/airwell)

A quiet minute for your breath.

Four guided breathing patterns, a circle that expands and contracts on your behalf, and nothing else. No account, no download, no timer running out on you.

**[airwell.jaybulb.com →](https://airwell.jaybulb.com)**

<img src="progress.svg" width="460">

## Screenshots

<p>
<img src="screenshots/airwell-light.png" alt="Airwell, light" width="640">
<img src="screenshots/airwell-dark.png" alt="Airwell, dark" width="640">
<img src="screenshots/airwell-phone.png" alt="Airwell on a phone" width="240">
</p>

## Features

- **Four patterns.** Box (4-4-4-4), 4-7-8, Relax, Coherent. Pick one, the circle does the counting.
- **One screen.** No settings, no sign-up, no ads.
- **Light and dark.** Follows your system theme.

## Platforms

| | |
|---|---|
| Web | This repo, deployed to Cloudflare Workers |
| iOS, macOS | `ios/`, xcodegen, WKWebView wrapper |

## Running locally

```bash
npx wrangler dev
```

## Deploying

```bash
npx wrangler deploy
```

## Architecture

<img src="architecture.svg" width="600">
