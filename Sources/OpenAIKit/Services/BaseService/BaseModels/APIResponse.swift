//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public struct APIResponse<T: Payload>: Codable {
    
    public let object: String?
    public let model: String?
    public let choices: [T]?
    public let usage: UsageResult?
}

