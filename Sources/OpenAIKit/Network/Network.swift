//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation
import os

public enum NetworkError: Error {
    
    case unableToCreateURL
    case unableToCreateURLComponents
    case unableToCreateFullURL
    case unableToSerializeBody
    case unableToSerializeResponse
    case statusCode(Int)
}

public protocol NetworkProtocol {
    
    func makeRequest(request: URLRequest) async throws -> Data
    
    func prepareRequest(auth: OpenAIAuth,
                        request: NetworkRequest,
                        body: Encodable?) throws -> URLRequest
}

public class Network {
    
    fileprivate let session: URLSession
    private let logger: Logger
    
    public init(session: URLSession = URLSession.shared,
                logger: Logger = Logger(subsystem: "OpenAIKit",
                                        category: "Network")) {
        self.session = session
        self.logger = logger
    }
}

extension Network: NetworkProtocol {
    
    public func makeRequest(request: URLRequest) async throws -> Data {
        
        logger.info("Calling \(#function)")
        
        let (data, response) = try await session.data(for: request)
        
        logger.info("validating response")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unableToSerializeResponse
        }
        
        logger.info("validating statusCode")
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        self.logger.info("dataTask response success")
        
        return data
    }
    
    public func prepareRequest(auth: OpenAIAuth,
                               request: NetworkRequest,
                               body: Encodable? = nil) throws -> URLRequest {
        
        logger.info("Calling \(#function)")
        
        logger.info("Creating URL for baseUrl")
        guard let url = URL(string: auth.baseUrl) else {
            throw NetworkError.unableToCreateURL
        }
        
        logger.info("Creating URLComponentes for url")
        guard var urlComponents = URLComponents(url: url,
                                                resolvingAgainstBaseURL: true) else {
            throw NetworkError.unableToCreateURLComponents
        }
        
        logger.info("Adding path to urlComponents")
        urlComponents.path = request.path
        
        guard let fullURL = urlComponents.url else {
            throw NetworkError.unableToCreateFullURL
        }
        
        logger.info("Creating URLRequest")
        var urlRequest = URLRequest(url: fullURL)
        
        logger.info("Adding request METHOD")
        urlRequest.httpMethod = request.method
        
        
        logger.info("Adding Headers")
        auth.baseHeader.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        guard let body = body else { return urlRequest }
        
        logger.info("Adding body to urlRequest")
        urlRequest.httpBody = try JSONEncoder().encode(body)
        
        return urlRequest
    }
}
