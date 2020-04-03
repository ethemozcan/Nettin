//
//  File.swift
//  
//
//  Created by Ethem Özcan on 01.04.20.
//

import Foundation

public class NettinCodable: NettinCodableProtocol {
    private var client: NettinClientProtocol
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?

    init(_ client: NettinClientProtocol = NettinClient(), dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?) {
        self.client = client
        self.dateDecodingStrategy = dateDecodingStrategy
    }

    public func get<T>(_ decodedClass: T.Type,
                       url: URL,
                       urlParameters: [String]?,
                       queryParameters: [String : String]?,
                       httpHeaders: [String : String]?,
                       completion: @escaping (Result<T, NettinError>) -> (Void)) where T : Decodable {

        client.get(url: url, urlParameters: urlParameters, queryParameters: queryParameters, httpHeaders: httpHeaders) { [weak self] result in
            switch result {
            case .failure(let error): completion(.failure(error))

            case .success(let data):
                let decoder = JSONDecoder()
                if let dateDecodingStrategy = self?.dateDecodingStrategy {
                    decoder.dateDecodingStrategy = dateDecodingStrategy
                }

                guard let data = data, let item = try? decoder.decode(T.self, from: data) else {
                    // Decoding Fail
                    completion(.failure(.jsonDecodingFail))
                    return
                }

                // success
                completion(.success(item))
            }
        }
    }
}
