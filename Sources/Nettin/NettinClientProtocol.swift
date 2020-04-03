//
//  File.swift
//  
//
//  Created by Ethem Özcan on 01.04.20.
//

import Foundation

public protocol NettinClientProtocol {
    func get(url: URL,
             urlParameters: [String]?,
             queryParameters: [String: String]?,
             httpHeaders: [String: String]?,
             completion: @escaping (Result<Data?, NettinError>) -> (Void))

    //TODO: ... post, put, etc.
}
