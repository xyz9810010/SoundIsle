# SoundIsle Security

## Threat Model
Primary risks:
- credential leakage
- malicious/compromised music server
- malicious redirects
- unsafe custom metadata/lyrics endpoints
- path traversal in downloads
- oversized/untrusted remote data
- sensitive logs

## Server URLs
User-configured LAN servers are allowed.
Do not apply a blanket “deny private IP” SSRF rule to primary music servers.

Third-party providers:
- never inherit music-server Authorization/Cookie/API Key;
- cannot access SecureStorage directly;
- must use narrowly scoped configuration.

## Redirects
When host changes:
- strip Authorization and other sensitive headers unless explicitly re-authorized;
- re-evaluate TLS/transport policy.

## TLS
- strict by default;
- HTTP LAN may be allowed with clear warning;
- no global Trust-All mode.

## File Safety
Sanitize generated filenames.
Never allow remote metadata to control parent directories.
Resolve final paths inside approved app storage roots.

## Logging
Redact:
`password, token, apiKey, Authorization, Cookie, sensitive query parameters`.

## Dependency Review
New dependencies require source, version, license, purpose, and maintenance justification.

## TLS Trust
V1 does not bypass TLS certificate validation globally. Self-signed/private PKI support, if added, requires explicit trust configuration; never implement an `accept all certificates` production switch.
