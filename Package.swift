import PackageDescription

let package = Package(
    name: "RedisProvider",
    dependencies: [
        // Pure-Swift Redis client implemented from the original protocol spec.
        .Package(url: "https://github.com/vapor/redis.git", majorVersion: 2),

        // Importing Vapor for access to the Provider protocol.
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ]
)
