import XCTest
import Vapor
@testable import RedisProvider
import Cache

class ProviderTests: XCTestCase {
    static let allTests = [
        ("testConfig", testConfig),
        ("testConfigMissing", testConfigMissing),
        ("testNotConfigured", testNotConfigured),
        ("testDatabaseSelect", testDatabaseSelect)
    ]

    func testConfig() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")
        try config.set("redis.hostname", RedisCache.testAddress)
        try config.set("redis.port", RedisCache.testPort)
        try config.addProvider(RedisProvider.Provider.self)
        let drop = try Droplet(config: config)

        XCTAssert(drop.cache is RedisCache)
    }

    func testConfigMissing() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")
        try config.addProvider(RedisProvider.Provider.self)
        
        do {
            _ = try Droplet(config)
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
        try config.addProvider(RedisProvider.Provider.self)

        let drop = try Droplet(config: config)

        XCTAssert(drop.cache is MemoryCache)
    }
    
    func testUrlConfig() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")
        try config.set("redis.url", "redis://:password@\(RedisCache.testAddress):\(RedisCache.testPort)/2")
        try config.addProvider(RedisProvider.Provider.self)
        
        let drop = try Droplet(config: config)
        
        XCTAssert(drop.cache is RedisCache)
    }
    
    func testDatabaseSelect() throws {
        var config = Config([:])
        try config.set("droplet.cache", "redis")
        try config.set("redis.hostname", RedisCache.testAddress)
        try config.set("redis.port", RedisCache.testPort)
        try config.set("redis.database", 2)
        try config.addProvider(RedisProvider.Provider.self)
        
        let drop = try Droplet(config: config)

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
