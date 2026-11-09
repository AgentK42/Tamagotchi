// Service Worker: App komplett offline verfügbar machen. VERSION wird von build.ps1 bei jedem Build erneuert.
const VERSION = 'moro-20261109-142434';
const CORE = ['./', './index.html', './manifest.webmanifest', './fonts/fonts.css',
  './fonts/bricolagegrotesque-600-latin.woff2', './fonts/bricolagegrotesque-600-latin-ext.woff2',
  './fonts/figtree-400-latin.woff2', './fonts/figtree-400-latin-ext.woff2',
  './fonts/ibmplexmono-500-latin.woff2', './fonts/ibmplexmono-500-latin-ext.woff2',
  './icons/icon-32.png', './icons/icon-192.png', './icons/icon-512.png', './icons/maskable-512.png', './icons/apple-touch-icon.png'];

self.addEventListener('install', e => {
  // cache: 'reload' umgeht den HTTP-Cache, damit eine neue Version auch wirklich die neuen Dateien speichert
  e.waitUntil(caches.open(VERSION)
    .then(c => c.addAll(CORE.map(u => new Request(u, { cache: 'reload' }))))
    .then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(k => k !== VERSION).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

// Offline zuerst: Die App kommt sofort aus dem Cache, auch bei schlechtem oder hängendem Netz
// (WLAN ohne Internet, Funkloch). Im Hintergrund wird nachgeladen; neue Versionen kommen über
// eine neue VERSION (neuer Service Worker) und sind beim nächsten Öffnen aktiv.
self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return; // die App lädt nichts von fremden Servern
  const nav = req.mode === 'navigate';
  const key = nav ? './index.html' : req; // jede Seitenanfrage (auch mit ?… oder #…) bekommt die App
  const cacheP = caches.open(VERSION);
  const fresh = fetch(req).then(res => {
    // Nur saubere eigene Antworten speichern (keine Weiterleitungen, Fehlerseiten oder Portal-Seiten)
    if (res.ok && res.type === 'basic' && !res.redirected) { const copy = res.clone(); return cacheP.then(c => c.put(key, copy)).then(() => res); }
    return res;
  }).catch(() => null);
  e.waitUntil(fresh); // Nachladen im Hintergrund zu Ende führen, auch wenn die Antwort schon aus dem Cache kam
  e.respondWith(cacheP.then(c => c.match(key, { ignoreSearch: nav })).then(async hit =>
    hit || (await fresh) || (nav && await (await cacheP).match('./index.html')) || Response.error()));
});
