import XCTest
import Vapor
@testable import VaporRedis

class ProviderTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic),
        ("testConfig", testConfig),
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
}
