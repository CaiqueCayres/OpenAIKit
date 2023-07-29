//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public protocol Payload: Codable { }

public struct TextResult: Payload {
    
    public let text: String
}

public struct MessageResult: Payload {
    
    public let message: ChatMessage?
    public let index: Int?
    public let finished: String?
    
    public enum CodingKeys: String, CodingKey {
        case message = "message"
        case index = "index"
        case finished = "finish_reason"
    }
}
