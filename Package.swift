import PackageDescription

let package = Package(
    name: "VaporRedis",
    dependencies: [
        // Pure-Swift Redis client implemented from the original protocol spec.
        .Package(url: "https://github.com/vapor/redbird.git", Version(2,0,0, prereleaseIdentifiers: ["alpha"])),

        // Importing Vapor for access to the Provider protocol.
        .Package(url: "https://github.com/vapor/vapor.git", Version(2,0,0, prereleaseIdentifiers: ["alpha"]))
    ]
)
