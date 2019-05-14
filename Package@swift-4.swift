// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "RedisProvider",
    dependencies: [
        // Pure-Swift Redis client implemented from the original protocol spec.
        .package(url: "https://github.com/vapor/redis.git", .upToNextMajor(from: "2.0.0")),

        // Importing Vapor for access to the Provider protocol.
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.0.0")),
    ]
)
