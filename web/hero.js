// Hero wall: Airwell's breather, one card per pattern (never two the same), each circle growing on the in-breath,
// holding, shrinking on the out-breath, with the phase and seconds left. Timings from the app's own presets.
(function () {
  var wall = document.getElementById('awall'); if (!wall) return;
  var still = matchMedia('(prefers-reduced-motion: reduce)').matches;
  var PATTERNS = [['Box', [4, 4, 4, 4]], ['4-7-8', [4, 7, 8, 0]], ['Relax', [4, 0, 6, 0]], ['Coherent', [5, 0, 5, 0]], ['Custom', [6, 2, 6, 2]], ['Custom', [3, 0, 5, 0]]];
  var NAMES = ['Breathe in', 'Hold', 'Breathe out', 'Hold'];
  var n = innerWidth <= 900 ? 4 : 6;
  var el = function (t, c, x) { var e = document.createElement(t); if (c) e.className = c; if (x != null) e.textContent = x; return e; };
  PATTERNS.slice(0, n).forEach(function (p, i) {
    var a = wall.appendChild(el('div', 'aw')), hd = a.appendChild(el('div', 'aw-hd')), b = a.appendChild(el('div', 'aw-b')), c = b.appendChild(el('div', 'aw-c')), ph = a.appendChild(el('div', 'aw-ph'));
    hd.appendChild(el('b', '', p[0])); var reps = hd.appendChild(el('span', '', p[1].join('-')));
    var label = ph.appendChild(el('span')), secs = ph.appendChild(el('b'));
    if (still) { label.textContent = 'Breathe'; c.style.transform = 'scale(1.5)'; return; }
    var phase = 0, left = 0, rep = 0, scale = 1;
    function next() {
      do { phase = (phase + 1) % 4; if (phase === 0) rep++; } while (!p[1][phase]);
      left = p[1][phase]; label.textContent = NAMES[phase];
      if (phase === 0 || phase === 2) { scale = phase === 0 ? 2 : 1; c.style.transition = 'transform ' + left + 's ease-in-out'; c.style.transform = 'scale(' + scale + ')'; }
      if (rep) reps.textContent = 'Rep ' + rep;
    }
    phase = 3; setTimeout(function () { next(); secs.textContent = left; setInterval(function () { left--; if (left <= 0) next(); secs.textContent = left; }, 1000); }, i * 600);
  });
})();

// Hero parallax: the wall drifts at 0.45, the copy lifts at 0.2 and fades. Off under reduced motion.
(function () {
  var bg = document.querySelector('.hero-bg'), copy = document.querySelector('.hero-copy');
  if (!bg || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  var t = 0;
  addEventListener('scroll', function () {
    if (t) return;
    t = requestAnimationFrame(function () {
      t = 0; var y = scrollY, h = innerHeight; if (y > h * 1.2) return;
      bg.style.setProperty('--py', (y * .45) + 'px');
      copy.style.transform = 'translate3d(0,' + (y * .2) + 'px,0)'; copy.style.opacity = Math.max(0, 1 - y / (h * .7));
    });
  }, { passive: true });
})();
