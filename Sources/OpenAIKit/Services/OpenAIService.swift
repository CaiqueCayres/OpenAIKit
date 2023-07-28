//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation
import os

public enum ServiceError: Error {
    
    case genericError(error: Error)
    case decodingError(error: Error)
    case apiError(ChatError)
}

public class OpenAIService {
    
    private let token: String
    private let network: NetworkProtocol
    private let logger: Logger
    
    public init(token: String,
                network: NetworkProtocol = Network(),
                logger: Logger = Logger(subsystem: "OpenAIKit",
                                        category: "OpenAIService")) {
        self.token = token
        self.logger = logger
        self.network = network
    }
    
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
