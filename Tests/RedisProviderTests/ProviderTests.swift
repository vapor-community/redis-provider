import XCTest
import Vapor
@testable import RedisProvider
import Cache

class ProviderTests: XCTestCase {
    static let allTests = [
        ("testManual", testManual),
        ("testConfig", testConfig),
        ("testConfigMissing", testConfigMissing),
        ("testNotConfigured", testNotConfigured),
    ]

    func testManual() throws {
        let drop = try Droplet()

        drop.cache = try RedisCache(
            hostname: RedisCache.testAddress,
            port: RedisCache.testPort
        )

        XCTAssert(drop.cache is RedisCache)
    }

    func testConfig() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")
        try config.set("redis.hostname", RedisCache.testAddress)
        try config.set("redis.port", RedisCache.testPort)

        let drop = try Droplet(config: config)
        try drop.addProvider(RedisProvider.Provider.self)

        XCTAssert(drop.cache is RedisCache)
    }

    func testConfigMissing() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")

        let drop = try Droplet(config: config)
        do {
            try drop.addProvider(RedisProvider.Provider.self)
            XCTFail("Should have failed.")
        } catch ConfigError.missingFile(let file) {
            XCTAssertEqual(file, "redis")
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }

    func testNotConfigured() throws {
        var config = Config([:])
        try config.set("droplet.cache", "memory")

        let drop = try Droplet(config: config)
        try drop.addProvider(RedisProvider.Provider.self)

        XCTAssert(drop.cache is MemoryCache)
    }
}
