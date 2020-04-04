import Foundation
import XCTest
@testable import Nettin

enum FakeErrorType: Error {
    case testError
}

final class NettinClientTests: XCTestCase {
    var nettinClient: NettinClient!
    var fakeSession = FakeURLSession()
    var fakeURL = URL(string: "http://www.ethem.eu")!

    override func setUp() {
        nettinClient = NettinClient(fakeSession)
    }

    func testRequestParameters() {
        let expectation = XCTestExpectation()

        let urlParameters = ["URLparam1", "URL param 2"]
        let queryParameters = ["queryParam": "Query Param Value"]
        let httpHeaders = ["headerParam": "header Value"]

        nettinClient.get(url: fakeURL,
                         urlParameters: urlParameters,
                         queryParameters: queryParameters,
                         httpHeaders: httpHeaders) { [weak self] _ in
                            let components = URLComponents(url: (self?.fakeSession.request.url)!, resolvingAgainstBaseURL: false)!
                            XCTAssertEqual(components.queryItems?.count, 1)
                            XCTAssertEqual(components.query, "queryParam=Query Param Value")
                            XCTAssertEqual(components.path, "/URLparam1/URL param 2")
                            XCTAssertEqual(components.host, "www.ethem.eu")
                            XCTAssertEqual(self?.fakeSession.request.allHTTPHeaderFields, ["headerParam": "header Value"])

                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testErrorCase() {
        let expectation = XCTestExpectation()

        fakeSession.fakeError = FakeErrorType.testError

        nettinClient.get(url: fakeURL,
                         urlParameters: nil,
                         queryParameters: nil,
                         httpHeaders: nil) { result in

                            switch result {
                            case .success(_):
                                assertionFailure()

                            case .failure(let nettinError):

                                switch nettinError {
                                case .connectionFailed(let error):
                                    if case FakeErrorType.testError = error {
                                        XCTAssert(true)
                                    } else {
                                        assertionFailure()
                                    }

                                default:
                                    assertionFailure()
                                    break
                                }
                            }

                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
