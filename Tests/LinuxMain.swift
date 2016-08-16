import XCTest
@testable import VaporRedisTestSuite

XCTMain([
     testCase(ProviderTests.allTests),
     testCase(RedisCacheTests.allTests),
])
