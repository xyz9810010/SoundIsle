# Real Navidrome read-only integration test (dev-environment, not the app).
# Runs reachability + auth-failure checks without credentials; with credentials it also
# exercises ping/getArtists/getAlbumList2/search3 against the real server.
#
# Usage:
#   ./tools/navidrome_integration.ps1
#   $env:NAVIDROME_USER='user'; $env:NAVIDROME_PASS='pass'; ./tools/navidrome_integration.ps1
$ErrorActionPreference = 'Continue'

$url = if ($env:NAVIDROME_URL) { $env:NAVIDROME_URL } else { 'http://192.168.5.3:4533' }
$user = $env:NAVIDROME_USER
$pass = $env:NAVIDROME_PASS

function Md5Hex([string]$s) {
  $md5 = [System.Security.Cryptography.MD5]::Create()
  $bytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($s))
  $md5.Dispose()
  return (($bytes | ForEach-Object { $_.ToString('x2') }) -join '')
}

function Get-Json([string]$url) {
  try {
    $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
    return $r.Content
  } catch {
    return $null
  }
}

Write-Output "== Navidrome integration target: $url =="

# 1. Reachability + server identity (no credentials needed)
$pingNoAuth = Get-Json "$url/rest/ping?f=json"
if ($pingNoAuth -match 'navidrome') {
  Write-Output 'PASS: server is Navidrome'
} else {
  Write-Output "FAIL/UNKNOWN: ping response = $pingNoAuth"
}

# 2. Auth-failure mapping (bogus token)
$bogus = "$url/rest/ping?u=__none__&t=00000000000000000000000000000000&s=00000000&v=1.16.1&c=SoundIsle&f=json"
$bogusBody = Get-Json $bogus
if ($bogusBody -match '"code":40' -or $bogusBody -match 'Wrong username or password') {
  Write-Output 'PASS: bogus auth -> code 40 (AUTH_FAILED)'
} else {
  Write-Output "FAIL/UNKNOWN: bogus auth response = $bogusBody"
}

# 3. Authenticated read APIs (only if credentials are provided via env)
if ($user -and $pass) {
  $salt = -join ((48..57 + 97..122) | Get-Random -Count 16 | ForEach-Object { [char]$_ })
  $token = Md5Hex ($pass + $salt)
  $auth = "u=$([uri]::EscapeDataString($user))&t=$token&s=$salt&v=1.16.1&c=SoundIsle&f=json"

  $pingBody = Get-Json "$url/rest/ping?$auth"
  if ($pingBody -match '"status":"ok"') {
    Write-Output 'PASS: authenticated ping -> ok'
  } else {
    Write-Output "FAIL: authenticated ping = $pingBody"
  }

  $artists = Get-Json "$url/rest/getArtists?$auth"
  if ($artists -match '"artists"') { Write-Output 'PASS: getArtists returned data' } else { Write-Output "FAIL: getArtists = $artists" }

  $albums = Get-Json "$url/rest/getAlbumList2?$auth&type=alphabeticalByName&offset=0&size=5"
  if ($albums -match '"albumList2"') { Write-Output 'PASS: getAlbumList2 returned data' } else { Write-Output "FAIL: getAlbumList2 = $albums" }

  $search = Get-Json "$url/rest/search3?$auth&query=test&songCount=5&songOffset=0&artistCount=0&albumCount=0"
  if ($search -match '"searchResult3"') { Write-Output 'PASS: search3 returned data' } else { Write-Output "FAIL: search3 = $search" }

  $ext = Get-Json "$url/rest/getOpenSubsonicExtensions?$auth"
  if ($ext -match '"openSubsonicExtensions"') { Write-Output 'PASS: getOpenSubsonicExtensions returned data' } else { Write-Output "FAIL: getOpenSubsonicExtensions = $ext" }

  $searchJ = ((Invoke-WebRequest -Uri "$url/rest/search3?$auth&query=love&songCount=2&songOffset=0&artistCount=0&albumCount=0" -UseBasicParsing -TimeoutSec 10).Content | ConvertFrom-Json)
  $songA = $searchJ.'subsonic-response'.searchResult3.song[0].id
  $songB = $searchJ.'subsonic-response'.searchResult3.song[1].id
  if ($songA -and $songB -and ($songA -ne $songB)) { Write-Output 'PASS: two distinct songs (different stream ids)' } else { Write-Output 'FAIL: could not fetch two distinct songs' }
  $streamCode = & curl.exe -s -r 0-1023 -o NUL -w '%{http_code}' "$url/rest/stream?$auth&id=$songA&format=raw"
  if ($streamCode -eq '206' -or $streamCode -eq '200') { Write-Output "PASS: stream returned audio (HTTP $streamCode)" } else { Write-Output "FAIL: stream HTTP $streamCode" }
} else {
  Write-Output 'SKIP: authenticated read-API tests (set NAVIDROME_USER / NAVIDROME_PASS to run)'
}
