//
//  File.swift
//  
//
//  Created by Ethem Özcan on 04.04.20.
//

import XCTest
import Foundation
@testable import Nettin

class FakeURLSession: URLSession {
    var fakeData: Data?
    var fakeURLRespnonse: URLResponse?
    var fakeError: Error?
    var request: URLRequest!

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        completionHandler(fakeData, fakeURLRespnonse, fakeError)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() { }
}
