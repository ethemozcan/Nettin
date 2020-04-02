//
//  File.swift
//  
//
//  Created by Ethem Özcan on 01.04.20.
//

import Foundation

public protocol NettinCodableProtocol {
    func get<T:Decodable>(_ decodedClass: T.Type,
                        url: URL,
                        urlParameters: [String]?,
                        queryParameters: [String: String]?,
                        httpHeaders: [String: String]?,
                        completion: @escaping (Result<T, NettinError>) -> (Void))
}
