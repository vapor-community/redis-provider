import XCTest
@testable import VaporRedis
@testable import Node

class RedisCacheTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic),
        ("testMissing", testMissing),
        ("testArray", testArray),
        ("testObject", testObject),
        ("testDelete", testDelete),
        ("testExpire", testExpire)
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

    func testArray() throws {
        try cache.set("array", [1])
        
        let array = try cache.get("array")?.array
        let value: Int = (array?[0].int) ?? 0
        
        XCTAssertEqual(value, 1)
    }
    
    func testObject() throws {
        try cache.set("object", Node([
            "key0": "value0",
            "key1": "value1"
        ]))
        
        let node = try cache.get("object")
        let value0: String = (node?["key0"]?.string) ?? "wrong"
        let value1: String = (node?["key1"]?.string) ?? "wrong"
        
        XCTAssertEqual(value0, "value0")
        XCTAssertEqual(value1, "value1")
    }

    func testDelete() throws {
        try cache.set("hello", 42)
        XCTAssertEqual(try cache.get("hello")?.string, "42")
        try cache.delete("hello")
        XCTAssertEqual(try cache.get("hello"), nil)
    }
    
    func testExpire() throws {
        try cache.set("ephemeral", 42, expiration: Date(timeIntervalSinceNow: 2))
        XCTAssertEqual(try cache.get("ephemeral")?.string, "42")
        sleep(3)
        XCTAssertEqual(try cache.get("ephemeral"), nil)
    }
}
