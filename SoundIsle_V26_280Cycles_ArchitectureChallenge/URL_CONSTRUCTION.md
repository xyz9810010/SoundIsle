# SoundIsle Server URL Construction

## Problem
User base URLs may include:
- scheme
- port
- reverse-proxy path prefix
- trailing slash

Never construct endpoints by brittle string concatenation.

## Rules
Normalize a user-provided server root while preserving an intentional path prefix.

Conceptually:
```text
https://example.com/music
+ OpenSubsonic REST endpoint
→ https://example.com/music/rest/...
```

Do not require user to enter `/rest`.

Do not silently drop reverse-proxy subpaths.

Redirect behavior remains governed by SECURITY.md / NETWORK_EDGE_CASES.md.

## Proxy Response Validation
A 2xx/redirect response containing an HTML login/error page is not valid OpenSubsonic JSON. Validate expected response shape/content and surface a protocol/proxy configuration error.
