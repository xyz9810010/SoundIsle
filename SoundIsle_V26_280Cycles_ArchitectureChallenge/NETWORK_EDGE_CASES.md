# SoundIsle Network Edge Cases

## Stream Expiry
Do not rely solely on absolute expiry timestamps. On authorization/read failure, a bounded source refresh may be attempted if policy allows.

## Range Resume
Before appending resumed bytes verify:
- response status semantics;
- Content-Range start;
- expected resource identity/validators when available;
- resulting size/integrity.

If validation fails, restart the temporary download rather than corrupting the final file.

## Search/Metadata Requests
Use cancellation or request-generation guards so stale results never replace newer user queries.

## Redirect Security
Cross-host redirects strip sensitive authentication unless the target is explicitly trusted by the relevant provider contract.
