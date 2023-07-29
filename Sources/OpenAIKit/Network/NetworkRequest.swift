//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

/// Protocol to define the requirements for making a network request.
///
/// Conforming types must specify a path, method, and base URL for the request.
public protocol NetworkRequest {
    
    /// The path of the request.
    var path: String { get }
    
    /// The HTTP method of the request.
    var method: String { get }
    
    /// The base URL of the request.
    var baseUrl: String { get }
}

/// Represents the endpoints of the OpenAI API.
///
/// Cases represent different functionalities provided by the API.
public enum Endpoint {
    
    case completions
    case edits
    case chat
    case images
    case embeddings
    case models
    case model(String)
}

extension Endpoint: NetworkRequest {
    
    /// The path of the request.
    ///
    /// Different cases have different paths based on the functionality they represent.
    public var path: String {
        switch self {
        case .completions:
            return "/v1/completions"
        case .edits:
            return "/v1/edits"
        case .chat:
            return "/v1/chat/completions"
        case .images:
            return "/v1/images/generations"
        case .embeddings:
            return "/v1/embeddings"
        case .models:
            return "/v1/models"
        case let .model(model):
            return "/v1/models/\(model)"
        }
    }
    
    /// The HTTP method of the request.
    ///
    /// Different cases use different methods based on the functionality they represent.
    public var method: String {
        switch self {
        case .completions,
                .edits,
                .chat,
                .images,
                .embeddings:
            return "POST"
        case .models,
                .model:
            return "GET"
        }
    }
    
    /// The base URL of the request.
    ///
    /// All requests have the same base URL.
    public var baseUrl: String {
        switch self {
        default:
            return "https://api.openai.com"
        }
    }
}
