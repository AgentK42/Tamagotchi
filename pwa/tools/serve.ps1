# Kleiner lokaler Webserver für die PWA (Service Worker brauchen http://localhost oder https).
# Aufruf:  pwsh -File pwa/tools/serve.ps1   →  http://localhost:8765/
param([int]$Port = 8765)
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Moro PWA läuft auf http://localhost:$Port/  (Strg+C beendet)"

$types = @{
  '.html' = 'text/html; charset=utf-8'; '.js' = 'text/javascript; charset=utf-8'; '.css' = 'text/css; charset=utf-8'
  '.webmanifest' = 'application/manifest+json'; '.json' = 'application/json'; '.png' = 'image/png'; '.svg' = 'image/svg+xml'
  '.md' = 'text/plain; charset=utf-8'; '.woff2' = 'font/woff2'
}

while ($listener.IsListening) {
  $ctx = $listener.GetContext(); $req = $ctx.Request; $res = $ctx.Response
  try {
    $path = [Uri]::UnescapeDataString($req.Url.AbsolutePath)
    if ($req.HttpMethod -eq 'POST' -and $path -eq '/__save-icon') {
      # Nur für tools/icons.html: speichert ein im Browser erzeugtes PNG nach pwa/icons/
      $name = [IO.Path]::GetFileName($req.QueryString['name'])
      if ($name -notmatch '^[\w-]+\.png$') { throw 'Ungültiger Dateiname' }
      $data = ([IO.StreamReader]::new($req.InputStream)).ReadToEnd() -replace '^data:image/png;base64,', ''
      $dir = Join-Path $root 'icons'; New-Item -ItemType Directory -Force $dir | Out-Null
      [IO.File]::WriteAllBytes((Join-Path $dir $name), [Convert]::FromBase64String($data))
      $bytes = [Text.Encoding]::UTF8.GetBytes("gespeichert: icons/$name"); $res.ContentType = 'text/plain; charset=utf-8'
    } else {
      if ($path.EndsWith('/')) { $path += 'index.html' }
      $full = [IO.Path]::GetFullPath((Join-Path $root ($path.TrimStart('/') -replace '/', '\')))
      if (-not $full.StartsWith($root) -or -not (Test-Path -LiteralPath $full -PathType Leaf)) {
        $res.StatusCode = 404; $bytes = [Text.Encoding]::UTF8.GetBytes('Nicht gefunden')
      } else {
        $bytes = [IO.File]::ReadAllBytes($full)
        $res.ContentType = $types[[IO.Path]::GetExtension($full)] ?? 'application/octet-stream'
        $res.Headers.Add('Cache-Control', 'no-cache')
      }
    }
    $res.ContentLength64 = $bytes.Length
    if ($req.HttpMethod -ne 'HEAD') { $res.OutputStream.Write($bytes, 0, $bytes.Length) }
  } catch {
    Write-Host "Fehler bei $($req.HttpMethod) $($req.Url.AbsolutePath): $($_.Exception.Message)"
    try { $res.StatusCode = 500 } catch {}
  } finally { try { $res.Close() } catch {} }
}
