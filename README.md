# UUIDShortener

Allow to shorten UUID, specially when using in URLs ; along with Vapor.

## Usage

```
// Shorten any UUID
let uuid = UUID() // F0E07462-68F1-4219-96FE-D98C8449CAF0
let base32 = try uuid.shortened(using: .base32) // e9dlbzsyrie7pfu5hhx66b1m8
let base58 = try uuid.shortened(using: .base58) // vKbtaFgee2NLZVnLW6yuuq
let base62 = try uuid.shortened(using: .base62) // 7kwJxwyrgxEyZAKcDMFE1W
let base66 = try uuid.shortened(using: .base64) // 3MU7hyqf526pr-SoO4isHM
let base90 = try uuid.shortened(using: .base90) // n#g|6HlzuCBbxY~bho1!

// And get the original UUID back:
let original = try UUID(shortened: base62, using: .base62)
```

### With Vapor

Soon!
