// Footer band: Airwell's things in a row (the wind mark, cloud, leaf, feather, wave, sun), cut like a line
// engraving in plain 2D canvas. Faint rules run across the band; inside the glyphs they thicken, and thicken again on
// the edge facing away from the light, so the glyphs look cut into the page. Drawn once per size and theme.
// ponytail: was a WebGL shader with a drifting light; it rendered as a black box on iPhone, so it is static now.
(function () {
  var band = document.querySelector('.word-band'), canvas = band && band.querySelector('canvas');
  if (!canvas) return;

  var mark = new Image(), tints = {};
  mark.src = 'mark.svg';

  // Each glyph is drawn white on a 100 unit square.
  var GLYPHS = [
    function (c) { // wind: the brand mark itself
      if (!mark.complete || !mark.naturalWidth) return;
      var key = c.fillStyle;
      if (!tints[key]) {
        var t = document.createElement('canvas'); t.width = t.height = 400;
        var tc = t.getContext('2d'); tc.drawImage(mark, 0, 0, 400, 400);
        tc.globalCompositeOperation = 'source-in'; tc.fillStyle = key; tc.fillRect(0, 0, 400, 400);
        tints[key] = t;
      }
      c.drawImage(tints[key], -6, -6, 112, 112);
    },
    function (c) { // cloud
      c.beginPath(); c.arc(34, 60, 16, 0, 7); c.arc(52, 48, 22, 0, 7); c.arc(70, 60, 16, 0, 7); c.fill();
      c.beginPath(); c.roundRect(18, 56, 68, 20, 10); c.fill();
    },
    function (c) { // leaf
      c.save(); c.translate(50, 54); c.rotate(-0.7);
      c.beginPath(); c.moveTo(-34, 0); c.quadraticCurveTo(0, -30, 34, 0); c.quadraticCurveTo(0, 30, -34, 0); c.fill();
      c.globalCompositeOperation = 'destination-out'; c.lineWidth = 3.5; c.beginPath(); c.moveTo(-28, 0); c.lineTo(30, 0); c.stroke();
      c.restore(); c.globalCompositeOperation = 'source-over';
      c.lineWidth = 5; c.lineCap = 'round'; c.beginPath(); c.moveTo(30, 78); c.lineTo(24, 86); c.stroke();
    },
    function (c) { // feather
      c.save(); c.translate(50, 50); c.rotate(0.6);
      c.beginPath(); c.moveTo(0, -42); c.bezierCurveTo(18, -24, 16, 18, 0, 34); c.bezierCurveTo(-16, 18, -18, -24, 0, -42); c.fill();
      c.globalCompositeOperation = 'destination-out'; c.lineWidth = 3;
      c.beginPath(); c.moveTo(0, -38); c.lineTo(0, 30); c.stroke();
      for (var i = 0; i < 5; i++) { c.beginPath(); c.moveTo(0, -24 + i * 11); c.lineTo(12, -30 + i * 11); c.stroke(); }
      c.restore(); c.globalCompositeOperation = 'source-over';
      c.save(); c.translate(50, 50); c.rotate(0.6); c.lineWidth = 4; c.lineCap = 'round'; c.beginPath(); c.moveTo(0, 34); c.lineTo(0, 46); c.stroke(); c.restore();
    },
    function (c) { // wave
      c.lineWidth = 9; c.lineCap = 'round';
      [40, 62].forEach(function (y) { c.beginPath(); for (var x = 12; x <= 88; x += 2) { var yy = y + 8 * Math.sin((x - 12) / 76 * Math.PI * 2); x === 12 ? c.moveTo(x, yy) : c.lineTo(x, yy); } c.stroke(); });
    },
    function (c) { // sun
      c.beginPath(); c.arc(50, 50, 18, 0, 7); c.fill();
      c.lineWidth = 6; c.lineCap = 'round';
      for (var i = 0; i < 8; i++) { var a = i * Math.PI / 4; c.beginPath(); c.moveTo(50 + Math.cos(a) * 27, 50 + Math.sin(a) * 27); c.lineTo(50 + Math.cos(a) * 38, 50 + Math.sin(a) * 38); c.stroke(); }
    }
  ];
  // Lays the glyphs out evenly across a w by h 2D context, in the given colour: one row, or two on a narrow band.
  function grid(w, h) {
    var n = GLYPHS.length, rows = w < h * 3 ? 2 : 1, per = Math.ceil(n / rows);
    return { rows: rows, per: per, cell: Math.min(h / rows * 0.86, w / per) };
  }
  function paint(c, w, h, colour) {
    var g = grid(w, h), gap = (w - g.cell * g.per) / g.per, rowH = h / g.rows;
    GLYPHS.forEach(function (draw, i) {
      var col = i % g.per, row = Math.floor(i / g.per);
      c.save(); c.translate(gap / 2 + col * (g.cell + gap), row * rowH + (rowH - g.cell) / 2 + rowH * 0.04); c.scale(g.cell / 100, g.cell / 100);
      c.fillStyle = c.strokeStyle = colour; draw(c); c.restore();
    });
  }

  var ctx = canvas.getContext('2d');
  if (!ctx) return;
  function layer(w, h) { var c = document.createElement('canvas'); c.width = w; c.height = h; return c; }
  // Horizontal rules `t` px thick, one every `pitch` px, kept only where `mask` is drawn (everywhere when null).
  function rules(w, h, pitch, t, colour, mask) {
    var c = layer(w, h), x = c.getContext('2d');
    x.fillStyle = colour;
    for (var y = 0; y < h; y += pitch) x.fillRect(0, Math.round(y + (pitch - t) / 2), w, Math.max(1, Math.round(t)));
    if (mask) { x.globalCompositeOperation = 'destination-in'; x.drawImage(mask, 0, 0); }
    return c;
  }
  var drawnW = 0;
  function draw() {
    var dpr = Math.min(window.devicePixelRatio || 1, 2), w = Math.round(canvas.clientWidth * dpr), h = Math.round(canvas.clientHeight * dpr);
    if (!w || !h) return;
    drawnW = w; canvas.width = w; canvas.height = h;
    var colour = getComputedStyle(band).color, pitch = Math.min(5 * dpr, Math.max(3 * dpr, grid(w, h).cell / 22)), s = Math.max(2, h * 0.014);
    var glyphs = layer(w, h); paint(glyphs.getContext('2d'), w, h, '#fff');
    // the shadow side: glyph pixels whose neighbour down and right is outside the glyph (light from the top left)
    var shade = layer(w, h), sc = shade.getContext('2d');
    sc.drawImage(glyphs, 0, 0); sc.globalCompositeOperation = 'destination-out'; sc.drawImage(glyphs, -s, -s);
    ctx.globalAlpha = 0.28; ctx.drawImage(rules(w, h, pitch, dpr * 0.75, colour, null), 0, 0);
    ctx.globalAlpha = 1; ctx.drawImage(rules(w, h, pitch, pitch * 0.32, colour, glyphs), 0, 0);
    ctx.drawImage(rules(w, h, pitch, pitch * 0.6, colour, shade), 0, 0);
    // fade out toward the legal line
    var g = ctx.createLinearGradient(0, h * 0.88, 0, h);
    g.addColorStop(0, '#000'); g.addColorStop(1, 'rgba(0,0,0,0)');
    ctx.globalCompositeOperation = 'destination-in'; ctx.fillStyle = g; ctx.fillRect(0, 0, w, h);
    ctx.globalCompositeOperation = 'source-over';
  }
  band.classList.add('live');
  draw();
  mark.addEventListener('load', draw);
  // iOS fires resize as the toolbar slides; only a width change needs a redraw
  window.addEventListener('resize', function () { if (Math.round(canvas.clientWidth * Math.min(window.devicePixelRatio || 1, 2)) !== drawnW) draw(); });
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', draw);
})();
