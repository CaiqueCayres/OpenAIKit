//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public struct ChatMessage: Codable {
    
    public let role: ChatRole
    public let content: String?
    public let functionCall: Function?

    public init(role: ChatRole,
                content: String?,
                functionCall: Function? = nil) {
        
        self.role = role
        self.content = content
        self.functionCall = functionCall
    }
    
    enum CodingKeys: String, CodingKey {
        case role = "role"
        case content = "content"
        case functionCall = "function_call"
    }
}

public struct ChatConversationInput: Encodable {
    
    let messages: [ChatMessage]
    let model: String
    
    let functions: [ChatFunctionInput]?
    let user: String?
    let temperature: Double?
    let topProbabilityMass: Double?
    let choices: Int?
    let stop: [String]?
    let maxTokens: Int?
    let presencePenalty: Double?
    let frequencyPenalty: Double?
    let logitBias: [Int: Double]?

    enum CodingKeys: String, CodingKey {
        
        case user
        case messages
        case model
        case temperature
        case topProbabilityMass = "top_p"
        case choices = "n"
        case stop
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case functions
    }
}
