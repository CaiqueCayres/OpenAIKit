//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public struct ChatError: Codable {
    
    public let error: Payload
    
    public struct Payload: Codable {
        
        public let message: String
        public let type: String
        public let param: String?
        public let code: String?
    }
}
