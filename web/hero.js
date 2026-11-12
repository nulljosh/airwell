// Hero: Airwell's breather, one big circle running Box breathing (the app's default preset), growing on the
// in-breath, holding, shrinking on the out-breath, with the phase and seconds left.
(function () {
  var wall = document.getElementById('awall'); if (!wall) return;
  var still = matchMedia('(prefers-reduced-motion: reduce)').matches;
  var T = [4, 4, 4, 4], NAMES = ['Breathe in', 'Hold', 'Breathe out', 'Hold'];
  var el = function (p, t, c) { var e = p.appendChild(document.createElement(t)); if (c) e.className = c; return e; };
  var b = el(wall, 'div', 'aw-b'), c = el(b, 'div', 'aw-c'), ph = el(b, 'div', 'aw-ph'), label = el(ph, 'span'), secs = el(ph, 'b');
  if (still) { label.textContent = 'Breathe'; c.style.transform = 'scale(1.5)'; return; }
  var phase = 3, left = 0;
  function next() {
    phase = (phase + 1) % 4; left = T[phase]; label.textContent = NAMES[phase];
    if (phase === 0 || phase === 2) { c.style.transition = 'transform ' + left + 's ease-in-out'; c.style.transform = 'scale(' + (phase === 0 ? 1.6 : 1) + ')'; }
  }
  next(); secs.textContent = left;
  setInterval(function () { if (--left <= 0) next(); secs.textContent = left; }, 1000);
})();

// Hero parallax: the breather drifts at 0.45, the copy lifts at 0.2 and fades. Off under reduced motion.
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
