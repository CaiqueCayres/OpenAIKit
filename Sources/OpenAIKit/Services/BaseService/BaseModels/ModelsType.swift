//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public enum ModelType {
    
    case chat(Chat)
    case codex(Codex)
    case feature(Feature)
    case embedding(Embedding)
    case other(String)
    
    public var modelName: String {
        switch self {
        case .chat(let model): return model.rawValue
        case .codex(let model): return model.rawValue
        case .feature(let model): return model.rawValue
        case .embedding(let model): return model.rawValue
        case .other(let modelName): return modelName
        }
    }

    public enum Chat: String {
        
        case gpt3 = "gpt-3.5-turbo"
        case gpt3_16k = "gpt-3.5-turbo-16k"
        case gpt4 = "gpt-4"
        case gpt4_32k = "gpt-4-32k"
    }
    
    public enum Codex: String {
    
        case davinci = "code-davinci-002"
        case cushman = "code-cushman-001"
    }
    
    public enum Feature: String {
        
        case davinci = "text-davinci-edit-001"
    }
    
    public enum Embedding: String {
        
        case ada = "text-embedding-ada-002"
    }
}
