import XCTest
@testable import LiteShuntSharedKit

final class LiteShuntPOCTests: XCTestCase {
    func test共享常量符合POC默认值() {
        XCTAssertEqual(LiteShuntSharedConstants.appGroupIdentifier, "group.com.zero.LiteShunt")
        XCTAssertEqual(LiteShuntSharedConstants.clashVergeLoopbackHost, "127.0.0.1")
        XCTAssertEqual(LiteShuntSharedConstants.clashVergeDefaultPort, 7_890)
    }
}
