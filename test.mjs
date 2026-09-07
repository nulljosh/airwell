import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(new URL("./web/index.html", import.meta.url), "utf8");
const patterns = [...html.matchAll(/data-pattern="([^"]+)"/g)].map(m => m[1]);

test("every preset is four non-negative numbers", () => {
  assert.ok(patterns.length >= 4);
  for (const p of patterns) {
    const n = p.split(",").map(Number);
    assert.equal(n.length, 4, p);
    assert.ok(n.every(x => Number.isFinite(x) && x >= 0), p);
  }
});

test("inline script parses", () => {
  const src = html.match(/<script>([\s\S]*?)<\/script>/)[1];
  new Function(src);
});
