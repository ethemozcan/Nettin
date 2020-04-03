//
//  File.swift
//  
//
//  Created by Ethem Özcan on 01.04.20.
//

import Foundation

class NettinClient {
    var session: URLSession

    init(_ session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }

    // MARK: HTTP Data Task
    private func httpDataTask(request: URLRequest, completion: @escaping (Result<Data?, NettinError>) -> (Void)) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // connection failed
                completion(.failure(.connectionFailed(error: error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                // no http response
                completion(.failure(.noHTTPResponse))
                return
            }

            if !(200...299 ~= httpResponse.statusCode) {
                // domain error
                var responseBody: String?

                if let data = data, let bodyString = String(bytes: data, encoding: .utf8) {
                    responseBody = bodyString
                }

                completion(.failure(.domainError(statusCode: httpResponse.statusCode, responseBody: responseBody)))
                return
            }

            // success
            completion(.success(data))
        }

        return dataTask
    }

    private func buildURL(_ url: URL,
                  _ urlParameters: [String]?,
                  _ queryParameters: [String : String]?,
                  _ httpHeaders: [String : String]?) -> URL? {
        var newURL = url

        urlParameters?.forEach { newURL.appendPathComponent($0) }

        if let queryParameters = queryParameters {
            var urlComponents = URLComponents(url: newURL, resolvingAgainstBaseURL: true)

            urlComponents?.queryItems = queryParameters.compactMap { key, value in
                URLQueryItem(name: key, value: value)
            }

            if let url = urlComponents?.url {
                newURL = url
            }
        }

        return newURL
    }
}

extension NettinClient: NettinClientProtocol {
    func get(url: URL,
             urlParameters: [String]?,
             queryParameters: [String : String]?,
             httpHeaders: [String : String]?,
             completion: @escaping (Result<Data?, NettinError>) -> (Void)) {

        guard let requestURL = buildURL(url, urlParameters, queryParameters, httpHeaders) else {
            assertionFailure("Invalid URL")
            return
        }

        var request = URLRequest(url: requestURL)

        httpHeaders?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        let dataTask = httpDataTask(request: request, completion: completion)
        dataTask.resume()
    }
}
