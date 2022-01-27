//
//  NetworkErrors.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import PromiseKit
import Moya

enum NetworkErrors: Error, LocalizedError {
    case connectionTimeout
    case forbidden(messages: String?)
    case noNetworkConnectivity
    case notFound(messages: String?)
    case unAuthorized(messages: String?)
    case other(messages: String?)
    
    var errorDescription: String? {
        switch self {
        case .connectionTimeout:
            return "No Network Access"
        case .forbidden(let messages):
            return messages ?? "Forbidden"
        case .noNetworkConnectivity:
            return "Turn on cellular data or use Wi-Fi to access the app"
        case .notFound(let messages):
            return messages ?? "Not Found"
        case .unAuthorized(let messages):
            return messages ?? "Unauthorized"
        case .other(let messages):
            return messages ?? "Unknown Error"
        }
    }
}

// ======================
// MARK: - Error Handling
// ======================
extension NetworkErrors {
    static func handle<T>(_ error: Error) -> Promise<T> {
        guard let moyaError = error as? MoyaError else { return Promise(error: error) }
        var result: Promise<T>!
        
        func parseErrorMessages(_ errorData: Data?) -> String? {
            
            return nil
        }
        //
        if case .underlying(let error, let moyaResponse) = moyaError, let response = moyaResponse {
            switch response.statusCode {
            case 400:
                result = Promise(error: NetworkErrors.other(messages: parseErrorMessages(response.data)))
            case 401:
                result = Promise(error: NetworkErrors.unAuthorized(messages: parseErrorMessages(response.data)))
            case 403:
                result = Promise(error: NetworkErrors.noNetworkConnectivity)
            case 404:
                result = Promise(error: NetworkErrors.notFound(messages: parseErrorMessages(response.data)))
            case 400..<500:
                result = Promise(error: NetworkErrors.other(messages: parseErrorMessages(response.data)))
            case 504:
                result = Promise(error: NetworkErrors.connectionTimeout)
            default:
                result = Promise(error: NetworkErrors.other(messages: parseErrorMessages(response.data) ?? error.localizedDescription))
            }
        } else {
            result = Promise(error: NetworkErrors.other(messages: nil))
        }
        
        return result
    }
}
