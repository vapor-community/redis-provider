import VaporRedis
import XCTest
import Transport


extension RedisCache {
    static var testPort: Transport.Port {
        return 6379
    }

    static var testAddress: String {
        return "127.0.0.1"
    }

    static func makeForTesting() -> RedisCache {
        do {
            return try RedisCache(hostname: testAddress, port: testPort)
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
