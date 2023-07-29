//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation
import os

/// Represents possible errors that can occur while handling network requests.
public enum NetworkError: Error {
    
    /// Unable to create a URL from a provided string.
    case unableToCreateURL
    
    /// Unable to create URLComponents from a provided URL.
    case unableToCreateURLComponents
    
    /// Unable to create a full URL from URLComponents.
    case unableToCreateFullURL
    
    /// Unable to serialize the request body to JSON.
    case unableToSerializeBody
    
    /// Unable to serialize the response to the expected format.
    case unableToSerializeResponse
    
    /// Received an unexpected HTTP status code.
    case statusCode(Int)
}

/// Protocol to define the requirements for network request handling.
public protocol NetworkProtocol {
    
    /// Sends a network request and returns the response data.
    ///
    /// - Parameter request: The request to be sent.
    func makeRequest(request: URLRequest) async throws -> Data
    
    /// Prepares a URLRequest from provided parameters.
    ///
    /// - Parameters:
    ///   - auth: The OpenAI authentication details.
    ///   - request: The network request details.
    ///   - body: The body of the request, if any.
    func prepareRequest(auth: OpenAIAuth,
                        request: NetworkRequest,
                        body: Encodable?) throws -> URLRequest
}

/// Handles network communication for the OpenAI API.
public class Network {
    
    fileprivate let session: URLSession
    private let logger: Logger
    
    /// Creates a new `Network` instance.
    ///
    /// - Parameters:
    ///   - session: The URLSession to be used for network communication. Defaults to `URLSession.shared`.
    ///   - logger: The Logger to be used for logging. Defaults to a custom Logger instance.
    public init(session: URLSession = URLSession.shared,
                logger: Logger = Logger(subsystem: "OpenAIKit",
                                        category: "Network")) {
        self.session = session
        self.logger = logger
    }
}

extension Network: NetworkProtocol {
    
    /// Sends a network request and returns the response data.
    ///
    /// Logs details of the request and response, and throws an error if any issues arise.
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
    
    /// Prepares a URLRequest from provided parameters.
    ///
    /// Logs the steps taken in preparing the request, and throws an error if any issues arise.
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
