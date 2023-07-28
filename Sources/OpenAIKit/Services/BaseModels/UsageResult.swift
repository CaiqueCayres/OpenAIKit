//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public struct UsageResult: Codable {
    
    public let promptTokens: Int
    public let completionTokens: Int?
    public let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
