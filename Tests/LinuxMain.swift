import XCTest
@testable import RedisProviderTests

XCTMain([
     testCase(ProviderTests.allTests),
     testCase(RedisCacheTests.allTests),
])
