# UUIDShortener

Allow to shorten UUID, specially when using in URLs ; along with Vapor.

## Usage

### Import in Package.swift

```
...
dependencies: [
    ...
    // UUID Shortener ✂️
    .package(url: "https://github.com/Dean151/uuid-shortener", from: "1.0.0"),
    ...
],
targets: [
    .target(
        ...
        dependencies: [
            ...
            .product(name: "UUIDShortener", package: "uuid-shortener"),
            ...
        ],
        ...
```

### Shorten & expand UUIDs

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

### With Vapor 💧

You may use short identifiers in URL instead of using the full base16 UUID.

One of the best for URLs is base62 (no special characters), although base64 will work here.

If you need to disambiguate characters, base58 with alike characters stripped is best. 

```
struct TodosController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("todo", ":identifier", use: getTodo)
    }

    private func getTodo(req: Request) throws -> EventLoopFuture<Todo> {
        guard let shortIdentifier = req.parameters.get("identifier"),
              let identifier = try? UUID(shortened: shortIdentifier, using: .base62) else {
            throw Abort(.badRequest, reason: "Missing or unparsable identifier")
        }
        return Todo.find(identifier, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    ...
}
```
