# Baut die PWA aus ..\moro.html (dieselbe App wie das Artefakt, aber im Echtzeit-Modus).
# Aufruf:  pwsh -File pwa/build.ps1
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$c = Get-Content -Raw -Encoding utf8 (Join-Path $root '..\moro.html')

if (-not $c.Contains('const REAL_TIME = false;')) { throw 'REAL_TIME-Schalter in moro.html nicht gefunden' }
$c = $c.Replace('const REAL_TIME = false;', 'const REAL_TIME = true;')
$c = $c.Replace('<meta name="claude:viewport-fit-sides" content="cover">', '')

# Schriften lokal statt von Google laden (Datenschutz, offline beim ersten Start)
$c = [regex]::Replace($c, '<link rel="preconnect" href="https://fonts\.(googleapis|gstatic)\.com"[^>]*>\s*', '')
$c = [regex]::Replace($c, '<link rel="stylesheet" href="https://fonts\.googleapis\.com/[^"]*">', '<link rel="stylesheet" href="fonts/fonts.css">')
if ($c -match 'fonts\.googleapis\.com|fonts\.gstatic\.com') { throw 'Es sind noch Google-Fonts-Verweise übrig' }

# moro.html ist ein Artefakt ohne <html>/<head>/<body>: hier ein vollständiges Dokument daraus machen
$titleEnd = $c.IndexOf('</title>') + 8
$bodyStart = $c.IndexOf('<div class="wrap">')
$headExtra = $c.Substring($titleEnd, $bodyStart - $titleEnd)
$body = $c.Substring($bodyStart)

$head = @'
<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#0D1220">
<meta name="color-scheme" content="dark">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="Moro">
<meta name="description" content="Moro wächst mit deinem Training und überbrückt die ersten Wochen, in denen man noch keine Veränderung sieht.">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icons/icon-32.png" sizes="32x32" type="image/png">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<title>Moro</title>
<style>
/* Ersatz für das Grundgerüst, das claude.ai beim Artefakt automatisch ergänzt */
:root { padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); -webkit-text-size-adjust: 100%; }
body { margin: 0; -webkit-tap-highlight-color: transparent; }
img { max-width: 100%; }
</style>
'@

$sw = @'
<script>
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker.register('./sw.js'));
</script>
'@

$out = $head + $headExtra + "</head>`n<body>`n" + $body + "`n" + $sw + "</body>`n</html>`n"
Set-Content -Encoding utf8 -NoNewline -Path (Join-Path $root 'index.html') -Value $out

# Icon-Generator bekommt dieselbe Zeichnung wie die App
$s = $c.IndexOf('/* ---------- Pixel-Zeichnung'); $e = $c.IndexOf('/* ---------- Zustand & Aktionen')
$t = Get-Content -Raw -Encoding utf8 (Join-Path $root 'tools\icons-template.html')
Set-Content -Encoding utf8 -NoNewline -Path (Join-Path $root 'tools\icons.html') -Value $t.Replace('/*DRAW*/', $c.Substring($s, $e - $s))

# Neue Cache-Version, damit installierte Apps das Update laden
$swf = Join-Path $root 'sw.js'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$swc = [regex]::Replace((Get-Content -Raw -Encoding utf8 $swf), "const VERSION = '[^']*';", "const VERSION = 'moro-$stamp';")
Set-Content -Encoding utf8 -NoNewline -Path $swf -Value $swc

"PWA gebaut: index.html, tools/icons.html, sw.js (Version moro-$stamp)"
