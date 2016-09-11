import VaporRedis
import XCTest


extension RedisCache {
    static var testPort: Int {
        return 6379
    }

    static var testAddress: String {
        return "127.0.0.1"
    }

    static func makeForTesting() -> RedisCache {
        do {
            return try RedisCache(address: testAddress, port: testPort)
        } catch {
            print()
            print()
            print("⚠️  Redis Not Configured ⚠️")
            print()
            print("Error: \(error)")
            print()
            print("You must configure Redis to run with the following configuration: ")
            print("    host: '\(testAddress)'")
            print("    port: '\(testPort)'")
            print("    password: none")
            print()

            print()

            XCTFail("Configure Redis")
            fatalError("Configure Redis")
        }
    }
}
