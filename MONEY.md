# Airwell Money

How Airwell makes money. The company plan is `REVENUE.md` in the Code root; the ledger is `GTM.md`.

## Price and rail

$0.99 upfront on the App Store, iPhone and Mac (ASC 6810806058). Apple keeps 15% under the Small Business Program, so each sale pays about $0.84. The web app at airwell.jaybulb.com stays free. The web is the trial and the store is the checkout.

## What is actually sold

The native app: custom patterns, history, streaks and a reminder. The four built-in patterns are generic and run free on the web. The landing art is dithered from public domain paintings, so nothing sold belongs to anyone else.

## Who pays and why

Someone who wants a breathing tool that works and asks for nothing else. Most breathing apps want a subscription. Airwell wants one dollar, once, and the native app keeps the history and reminders that the web page does not.

## Cost to serve

No paid API, no accounts, no server code. Hosting is Cloudflare's free tier, static assets on one Worker.

## Where we are

- 2026-09-10: renamed to Airwell everywhere except the bundle ID.
- 2026-09-20: price set to $0.99.
- 2026-10-03: the native rewrite was resubmitted. The earlier web view build was rejected under 4.3(a).
- Revenue: no verified number (the App Store Connect key cannot read sales yet).

## Role in the company plan

Catalogue. GTM.md lists it as a $0.99 app that is free on the web. It serves Stage 0 of REVENUE.md as one more proof that a stranger pays a dollar. It is not a hero app, so it gets no push of its own.

## Next

Give the App Store Connect key the Sales role, then read the first month of Airwell sales against its web visits. If the store sells nothing for a month, the price goes back to free.

## Million, billion, trillion

**A million.** Airwell is the breathing app people recommend because it costs one dollar and never asks for a login.

**A billion.** Airwell ships as the calm tool on every Joshua Tree machine, the thing you open when you need to slow down.

**A trillion.** Airwell is a small habit that comes with every device, and nobody thinks about where it came from.

## Change it

`asc pricing schedule create --app 6810806058 --price 0.99 --base-territory USA --start-date YYYY-MM-DD`. Swap `--price 0.99` for `--free` to revert. No build, no review. Only with Joshua's yes in chat.

Anyone who got Airwell while it was free keeps it free.

*ASC 6810806058. Verified 2026-11-02.*
