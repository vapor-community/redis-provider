import XCTest
@testable import VaporRedisTests

XCTMain([
     testCase(ProviderTests.allTests),
     testCase(RedisCacheTests.allTests),
])
