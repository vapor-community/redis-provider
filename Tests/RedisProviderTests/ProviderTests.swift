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
        ("testDatabaseSelect", testDatabaseSelect)
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
    
    func testDatabaseSelect() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")
        try config.set("redis.hostname", RedisCache.testAddress)
        try config.set("redis.port", RedisCache.testPort)
        try config.set("redis.database", 2)
        
        let drop = try Droplet(config: config)
        try drop.addProvider(RedisProvider.Provider.self)

        let key = UUID().uuidString
        try drop.cache.set(key, "bar")
        
        XCTAssertEqual("bar", try drop.cache.get(key)?.string)

        // Verify that the value is in fact stored in database 2
        let cache = try RedisCache(
            hostname: RedisCache.testAddress,
            port: RedisCache.testPort
        )

        let client = try cache.makeClient()
        XCTAssertNil(try client.command(Command.get, [key])?.string)
        try client.command(try Command("select"), ["2"])
        XCTAssertEqual("bar", try client.command(Command.get, [key])?.string)
    }
}
