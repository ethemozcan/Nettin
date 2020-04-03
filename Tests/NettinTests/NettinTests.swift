import XCTest
@testable import Nettin

struct testResponse: Codable {
    let text: String
    let int: Int
    let date: Date
}

final class NettinTests: XCTestCase {
    var nettinClient: FakeNettinClient!
    var networkCodable: NettinCodableProtocol!
    let formatter = DateFormatter()

    lazy var fakeResponse: String = {
        """
        {
            "text": "Text value",
            "int": 1881,
            "date": "20200409T080506Z"
        }
        """
    }()

    override func setUp() {
        nettinClient = FakeNettinClient()
        networkCodable = NettinCodable(nettinClient, dateDecodingStrategy: nil)
        networkCodable.dateDecodingStrategy = .formatted(formatter)
    }

    func testNettinCodable() {
        let expectation = XCTestExpectation()

        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        nettinClient.jsonString = fakeResponse
        networkCodable.get(testResponse.self,
                           url: URL(string: "http:www.ethem.eu")!,
                           urlParameters: nil,
                           queryParameters: nil,
                           httpHeaders: nil) { [weak self] result in

                            switch result {
                            case .failure(let error): XCTAssert(false, error.localizedDescription)

                            case .success(let response):
                                XCTAssertEqual(response.text, "Text value")
                                XCTAssertEqual(response.int, 1881)
                                XCTAssertEqual(response.date, self?.formatter.date(from: "20200409T080506Z"))
                            }

                            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.3)
    }
}
