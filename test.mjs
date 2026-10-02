import vm from "node:vm";
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
  const src = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]).find(s => s.includes("function runPhase"));
  new Function(src);
});


test("changing a running preset keeps one timer and stop cancels it", () => {
  const elements = new Map();
  const element = id => {
    if (!elements.has(id)) elements.set(id, {
      style: {}, textContent: "", addEventListener() {}, setAttribute() {}
    });
    return elements.get(id);
  };
  const timers = new Map();
  let nextId = 0;
  const context = {
    document: {
      getElementById: element, querySelectorAll: () => [],
      querySelector: () => null, addEventListener() {}
    },
    localStorage: { getItem: () => null, setItem() {} },
    setTimeout: (callback, delay) => {
      timers.set(++nextId, { callback, delay });
      return nextId;
    },
    clearTimeout: id => timers.delete(id)
  };
  const src = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]).find(s => s.includes("function runPhase"));
  vm.runInNewContext(src + `
    start();
    setPreset('5,0,5,0');
    globalThis.stopBreathing = stop;
  `, context);
  assert.equal(timers.size, 1);
  assert.equal([...timers.values()][0].delay, 5000);
  const tick = () => {
    const [id, timer] = [...timers][0];
    timers.delete(id);
    timer.callback();
  };
  tick();
  assert.equal(element('label').textContent, 'Exhale');
  assert.equal(timers.size, 1);
  context.stopBreathing();
  assert.equal(timers.size, 0);
  assert.equal(element('label').textContent, 'Breathe');
});
