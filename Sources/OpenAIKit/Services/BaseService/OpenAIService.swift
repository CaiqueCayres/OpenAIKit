//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation
import os

/// Represents possible errors that can occur while handling service requests.
public enum ServiceError: Error {
    
    /// A generic error that occurred during the service request.
    case genericError(error: Error)
    
    /// An error occurred while decoding the response to the expected format.
    case decodingError(error: Error)
    
    /// An error returned by the OpenAI API.
    case apiError(ChatError)
}

/// Provides service functions for the OpenAI API.
public class OpenAIService {
    
    private let token: String
    private let network: NetworkProtocol
    private let logger: Logger
    
    /// Creates a new `OpenAIService` instance.
    ///
    /// - Parameters:
    ///   - token: The bearer token for OpenAI API authorization.
    ///   - network: The network handler used for API requests. Defaults to a `Network` instance.
    ///   - logger: The Logger to be used for logging. Defaults to a custom Logger instance.
    public init(token: String,
                network: NetworkProtocol = Network(),
                logger: Logger = Logger(subsystem: "OpenAIKit",
                                        category: "OpenAIService")) {
        self.token = token
        self.logger = logger
        self.network = network
    }
    
    /// Performs a network request to the OpenAI API and decodes the response.
    ///
    /// - Parameters:
    ///   - request: The network request to be sent.
    ///   - prompt: The request body, if any.
    ///
    /// - Returns: The response, decoded to the expected type.
    ///
    /// - Throws: An error if any issues occur during the network request or decoding.
    public func perform<T: Decodable>(request: NetworkRequest,
                                      prompt: Encodable?) async throws -> T {
        
        let api = OpenAIAuth(token: token)
        
        logger.info("Preparing Request")
        let urlRequest = try network.prepareRequest(auth: api,
                                                    request: request,
                                                    body: prompt)
        
        logger.info("Making Request")
        let data = try await network.makeRequest(request: urlRequest)
        
        logger.info("Trying To Decode Request")
        if let result = try? JSONDecoder().decode(T.self, from: data) {
            return result
        } else {
            do {
                logger.info("Trying To Decode API Error")
                let error = try JSONDecoder().decode(ChatError.self, from: data)
                throw ServiceError.apiError(error)
            } catch {
                throw ServiceError.decodingError(error: error)
            }
        }
    }
}
