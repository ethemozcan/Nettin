//
//  File.swift
//  
//
//  Created by Ethem Özcan on 02.04.20.
//

import XCTest
import Foundation
@testable import Nettin

class FakeNettinClient: NettinClientProtocol {
    var jsonString: String!

    func get(url: URL, urlParameters: [String]?, queryParameters: [String : String]?, httpHeaders: [String : String]?, completion: @escaping (Result<Data?, NettinError>) -> (Void)) {
        completion(.success(jsonString.data(using: .utf8)))
    }
}
