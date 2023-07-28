//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation
import os

public protocol ChatServiceProtocol {
    
    func sendChat(with messages: [ChatMessage]) async throws -> OpenAIResponse<MessageResult>
}

public class ChatService: OpenAIService {
    
    public var model: ModelType = .chat(.gpt3)

    public var choices: Int = 1
    public var temperature: Double = 1
    public var topProbabilityMass: Double = 0
    public var presencePenalty: Double = 0
    public var frequencyPenalty: Double = 0

    public var functions: [ChatFunctionInput]?
    public var user: String?
    public var stop: [String]?
    public var maxTokens: Int?
    public var logitBias: [Int: Double]?
    
    init(token: String) {
        super.init(token: token)
    }
}

extension ChatService: ChatServiceProtocol {
    
    public func sendChat(with messages: [ChatMessage]) async throws -> OpenAIResponse<MessageResult> {
        
        let endpoint: Endpoint = .chat
        
        let body = ChatConversationInput(messages: messages,
                                         model: self.model.modelName,
                                         functions: self.functions,
                                         user: self.user,
                                         temperature: self.temperature,
                                         topProbabilityMass: self.topProbabilityMass,
                                         choices: self.choices,
                                         stop: self.stop,
                                         maxTokens: self.maxTokens,
                                         presencePenalty: self.presencePenalty,
                                         frequencyPenalty: self.frequencyPenalty,
                                         logitBias: self.logitBias)
        
        return try await perform(request: endpoint, prompt: body)
    }
}
