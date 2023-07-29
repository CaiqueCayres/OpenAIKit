//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation
import os

public protocol ChatServiceProtocol {
    
    func sendChat(with messages: [ChatMessage]) async throws -> APIResponse<MessageResult>
}

public class ChatService {
    
    private let service: OpenAIService
    private let logger: Logger
    
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
    
    public init(token: String,
                logger: Logger = Logger(subsystem: "OpenAIKit",
                                        category: "ChatService")) {
        self.service = OpenAIService(token: token)
        self.logger = logger
    }
}

extension ChatService: ChatServiceProtocol {
    
    public func sendChat(with messages: [ChatMessage]) async throws -> APIResponse<MessageResult> {
        
        let endpoint: Endpoint = .chat
        
        let body = ChatInput(model: self.model.modelName,
                             messages: messages,
                             functions: self.functions,
                             temperature: self.temperature,
                             topProbabilityMass: self.topProbabilityMass,
                             choices: self.choices,
                             stop: self.stop,
                             maxTokens: self.maxTokens,
                             presencePenalty: self.presencePenalty,
                             frequencyPenalty: self.frequencyPenalty,
                             logitBias: self.logitBias,
                             user: self.user)
        
        return try await service.perform(request: endpoint, prompt: body)
    }
}
