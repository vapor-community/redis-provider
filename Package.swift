import PackageDescription

let package = Package(
    name: "VaporRedis",
    dependencies: [
        // Pure-Swift Redis client implemented from the original protocol spec.
        .Package(url: "https://github.com/czechboy0/Redbird.git", majorVersion: 0, minor: 9),

        // Importing Vapor for access to the Provider protocol.
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 0), // FIXME: will be 0.17
    ]
)
