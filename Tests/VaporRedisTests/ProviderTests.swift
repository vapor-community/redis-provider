import XCTest
import Vapor
@testable import VaporRedis

class ProviderTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic),
        ("testConfig", testConfig),
        ("testUrl", testUrl),
        ("testUrlWithDefaultPort", testUrlWithDefaultPort),
        ("testConfigUrl", testConfigUrl)
    ]

    func testBasic() throws {
        let provider = try VaporRedis.Provider(address: RedisCache.testAddress, port: RedisCache.testPort)
        XCTAssert(provider.provided.cache is RedisCache)
    }

    func testConfig() throws {
        let drop = Droplet()
        let provider = try VaporRedis.Provider(config: drop.config)
        XCTAssert(provider.provided.cache is RedisCache)
    }

    func testUrl() throws {
        let provider = try VaporRedis.Provider(url: "redis://ignored@localhost:6379/ignored")
        XCTAssert(provider.provided.cache is RedisCache)
    }

    func testUrlWithDefaultPort() throws {
        let provider = try VaporRedis.Provider(url: "redis://ignored@localhost/ignored")
        XCTAssert(provider.provided.cache is RedisCache)
    }
    
    func testConfigUrl() throws {
        let config = Config(["redis": ["url": "redis://ignored@localhost:6379/ignored"]])
        let provider = try VaporRedis.Provider(config: config)
        XCTAssert(provider.provided.cache is RedisCache)
    }
}
