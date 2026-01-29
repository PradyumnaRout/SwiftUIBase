//
//  NetworkError.swift
//  CombineMVVM
//
//  Created by hb on 7/14/22.
//

import Foundation

//public enum NetworkError: Error {
//    
//    // MARK: - Client Error: 400...499
//    case clientError(statusCode: Int, errorMessage: String)
//    
//    // MARK: - Server Error: 500...599
//    case serverError(statusCode: Int, errorMessage: String)
//    
//    // MARK: - Parsing Error
//    case parsingError(statusCode: Int, errorMessage: String)
//    case badURL(_ errorMessage: String)
//    case invalidJSON(_ error: String)
//    
//    case requestError(statusCode: Int, errorMessage: String)
//    
//    case internetConnectionError(statusCode: Int, errorMessage: String)
//    
//    // MARK: Dynamic Error Getting From Server
//    case dynamicError(statusCode: Int, errorData: Any)
//    
//    // MARK: - Other
//    case other(statusCode: Int, error: String)
//    
//    // MARK: - Network Error With Status Code
//    case requestErrorMessageWithStatusCode(statusCode: Int, errorMessage: String)
//    
//    func erroMessage() -> (Int, String?, Any?) {
//        switch self {
//        case .requestErrorMessageWithStatusCode(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .clientError(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .serverError(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .parsingError(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .internetConnectionError(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .requestError(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .other(let statusCode, let message):
//            return (statusCode, message, nil)
//        case .dynamicError(let statusCode, let errorData):
//            return (statusCode, "", errorData)
//        case .badURL(let message):
//            return (0, message, nil)
//        case .invalidJSON(let message):
//            return (0, message, nil)
//        }
//    }
//}

enum NetworkError: Error, LocalizedError {
    
    // MARK: - Client Error: 400...499
    case clientError(statusCode: Int)
    // MARK: - Parsing Error
    case parsingError(error: Error)
    case requestError(errorMessage: String)
    // MARK: - Common network cases
    case badURL
    case badRequest(statusCode: Int)
    case requestFailed(error: Error)
    case invalidResponse
    case noInternetConnection
    case timeout
    case paymentRequired
    // MARK: - Server Error: 500...599
    case serverError(statusCode: Int, data: Data?)
    case unauthorized
    case forbidden
    case notFound
    case payloadTooLarge
    case unprocessableEntity
    case decodingError(error: Error)
    case unknown(statusCode: Int?, error: Error)
    
    
    // MARK: - Custom error description
    var errorDescription: String? {
        switch self {
        case .clientError(let statusCode):
            return "Client error. Status code: \(statusCode)"
        case .parsingError(let error):
            return "Erorr in parsing.\(error.localizedDescription)"
        case .requestError(let errorMessage):
            return errorMessage
        case .badURL:
            return "The URL provided was invalid."
        case .badRequest(let statusCode):
            return "The request provided was bad. Status code: \(statusCode)"
        case .requestFailed(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .noInternetConnection:
            return "No internet connection."
        case .timeout:
            return "The request timed out."
        case .paymentRequired:
            return "Required payment."
        case .serverError(let statusCode, _):
            return "Server error with status code: \(statusCode)"
        case .unauthorized:
            return "Unauthorized access. Please login again."
        case .forbidden:
            return "Forbidden access to this resource."
        case .notFound:
            return "The requested resource was not found."
        case .payloadTooLarge:
            return "The uploaded data is too large to process."
        case .unprocessableEntity:
            return "The request conditions were not met."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .unknown(_, let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
    
    static func throwNetworkError(statusCode: Int, data: Data) throws {
        switch statusCode {
        case 200..<299:
            // Success
            break
        case 400:
            throw NetworkError.badRequest(statusCode: statusCode)
        case 401:
            throw NetworkError.unauthorized
        case 402:
            throw NetworkError.paymentRequired
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 413:
            throw NetworkError.payloadTooLarge
        case 422:
            throw NetworkError.unprocessableEntity
        case 500...599:
            throw NetworkError.serverError(statusCode: statusCode, data: data)
        default:
            throw NetworkError.serverError(statusCode: statusCode, data: data)
        }
    }
    
    static func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .requestFailed(error: urlError)
            }
        } else if let decodingError = error as? DecodingError {
            return .decodingError(error: decodingError)
        } else {
            return .unknown(statusCode: nil, error: error)
        }
    }
}



extension Encodable {
    func encode() -> Data? {
            do {
                return try JSONEncoder().encode(self)
            } catch {
                return nil
            }
        }
}
