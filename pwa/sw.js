// Service Worker: App offline verfügbar machen. VERSION wird von build.ps1 bei jedem Build erneuert.
const VERSION = 'moro-20261106-092106';
const CORE = ['./', './index.html', './manifest.webmanifest', './fonts/fonts.css',
  './fonts/bricolagegrotesque-600-latin.woff2', './fonts/bricolagegrotesque-600-latin-ext.woff2',
  './fonts/figtree-400-latin.woff2', './fonts/figtree-400-latin-ext.woff2',
  './fonts/ibmplexmono-500-latin.woff2', './fonts/ibmplexmono-500-latin-ext.woff2',
  './icons/icon-32.png', './icons/icon-192.png', './icons/icon-512.png', './icons/maskable-512.png', './icons/apple-touch-icon.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(VERSION).then(c => c.addAll(CORE)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(k => k !== VERSION).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return; // die App lädt nichts von fremden Servern
  // Eigene Dateien: erst Netz (damit Updates sofort ankommen), offline aus dem Cache
  e.respondWith(
    fetch(req).then(res => {
      if (res.ok) { const copy = res.clone(); caches.open(VERSION).then(c => c.put(req, copy)); }
      return res;
    }).catch(() => caches.match(req).then(hit => hit || caches.match('./index.html')))
  );
});
