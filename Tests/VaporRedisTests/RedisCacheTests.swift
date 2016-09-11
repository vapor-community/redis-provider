import XCTest
@testable import VaporRedis

class RedisCacheTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic),
        ("testMissing", testMissing),
        ("testNonCompatible", testNonCompatible),
        ("testDelete", testDelete),
    ]

    var cache: RedisCache!

    override func setUp() {
    	cache = RedisCache.makeForTesting()
    }

    func testBasic() throws {
    	try cache.set("hello", "world")
    	XCTAssertEqual(try cache.get("hello")?.string, "world")
    }

    func testMissing() throws {
        XCTAssertEqual(try cache.get("not-here"), nil)
    }

    func testNonCompatible() throws {
        do {
            try cache.set("array", [1])
        } catch RedisCache.Error.incompatibleValue {
            // good
        }
    }

    func testDelete() throws {
        try cache.set("ephemeral", 42)
        XCTAssertEqual(try cache.get("ephemeral")?.string, "42")
        try cache.delete("ephemeral")
        XCTAssertEqual(try cache.get("ephemeral"), nil)
    }
}
