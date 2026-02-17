//
//  NetworkService.swift
//  CombineMVVM
//
//  Created by hb on 7/14/22.
//

import Foundation
import UIKit
import SwiftUI


@available(iOS 17.0, *)
public class NetworkService {
    
    static let shared = NetworkService()
    
    public var requestTimeOut: Float = 30
    @State private var network = NetworkMonitor()
    
    public init() {}
    
    
    public func dataRequest<model: WSResponseData>(with inputRequest: RouterProtocol, showHud: Bool = false)  async throws -> WSResponse<model> {
        
        if !(network.isConnected ?? true) {
            HUDPresenter.shared.hide()
            throw NetworkError.mapError(NetworkError.noInternetConnection)
        }
        if showHud {
            HUDPresenter.shared.show()
        }
        NetworkService.shared.printInputRequest(with: inputRequest)
        
        guard let request = try? inputRequest.buildURLRequest() else {
            print("Failed to create URL request")
            HUDPresenter.shared.hide()
            throw NetworkError.requestError(errorMessage: "Bad URL Request")
        }
        
        do  {
            let (data, response) = try await URLSession.shared.data(for: request)
            HUDPresenter.shared.hide()
            try NetworkService.shared.handleResponse(output: (data, response), inputRequest: inputRequest)
            let finalResultedData: Data = try NetworkService.shared.decryptResponseData(data: data)
            let decodedData = try JSONDecoder().decode(WSResponse<model>.self, from: finalResultedData)
            return decodedData
        } catch let error {
            HUDPresenter.shared.hide()
            throw NetworkError.mapError(error)
        }
    }
    
    func dynamicDataRequest<model: Codable>(with inputRequest: RouterProtocol, showHud: Bool = false) async throws -> model {
        if showHud {
            HUDPresenter.shared.show()
        }
        NetworkService.shared.printInputRequest(with: inputRequest)
        guard let request = try? inputRequest.buildURLRequest() else {
            print("Failed to create URL request")
            throw NetworkError.requestError(errorMessage: "Bad URL Request")
        }
        
        do  {
            let (data, response) = try await URLSession.shared.data(for: request)
            try NetworkService.shared.handleResponse(output: (data, response), inputRequest: inputRequest)
            let decodedData = try JSONDecoder().decode(model.self, from: data)
            return decodedData
        } catch let error {
            throw NetworkError.mapError(error)
        }
    }
    
}

extension NetworkService {
    
    private func printInputRequest(with inputRequest: RouterProtocol) {
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
    }
    
    private func decryptResponseData(data: Data) throws -> Data {
        if AppConstants.useAES256Encryption {
            // Decrypt response body
            let decryptedString = try AES256.shared.decrypt(data: data)
            guard let decryptedData = decryptedString.data(using: .utf8) else {
                throw AESError.decryptionFailed
            }
            return decryptedData
        }
        return data
    }
    
    private func handleResponse(output: (data: Data, response: URLResponse), inputRequest: RouterProtocol? = nil) throws {
        HUDPresenter.shared.hide()
        guard let httpResponse = output.response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try NetworkError.throwNetworkError(statusCode: httpResponse.statusCode, data: output.data)
        
        if let inputRequest = inputRequest {
            let request = try? inputRequest.buildURLRequest()
            let resp = output.response as? HTTPURLResponse
            let responseString = String(data: output.data, encoding: .utf8)
            let error = URLError(.badServerResponse) as NSError
            Debug.printRequest(request, response: resp, responseString: responseString, error: error)
        }
    }
}

public struct Boundary {
    static public let boundary = "Boundary-\(UUID().uuidString)"
}

