import XCTest
@testable import Nettin

final class NettinTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Nettin().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
