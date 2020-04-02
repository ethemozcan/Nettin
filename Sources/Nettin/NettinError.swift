//
//  File.swift
//  
//
//  Created by Ethem Özcan on 01.04.20.
//

import Foundation

public enum NettinError : Error {
    case connectionFailed(error: Error)
    case noHTTPResponse
    case domainError(statusCode: Int, responseBody: String?)
    case jsonDecodingFail
    case responseError(responseStatus: String, errorMessage: String?)
}
