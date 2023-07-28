//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation


public protocol NetworkRequest {
    
    var path: String { get }
    var method: String { get }
    var baseUrl: String { get }
}

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
    
    public var baseUrl: String {
        switch self {
        default:
            return "https://api.openai.com"
        }
    }
}
