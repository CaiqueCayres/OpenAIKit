//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

//MARK: - Chat Funcitons Inputs
public struct ChatFunctionInput: Encodable {
    
    public let name: String
    public let description: String
    private let parameters: FunctionParameter
    private let required: [String]
    
    init(name: String,
         description: String,
         arguments: [FunctionArgumentInput]) {
        
        self.name = name
        self.description = description
        self.parameters = FunctionParameter(properties: arguments)
        self.required = arguments
            .filter{ $0.required }
            .map{ $0.name }
    }
    
    struct FunctionParameter: Codable {
        
        var type: String = "object"
        let properties: [FunctionArgumentInput]
        
        func encode(to encoder: Encoder) throws {
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.type, forKey: .type)
            
            var propertiesDict: [String: FunctionArgumentInput] = [:]
            
            for property in properties {
                propertiesDict[property.name] = property
            }
            
            try container.encode(propertiesDict, forKey: .properties)
        }
    }
}

public struct FunctionArgumentInput: Codable {
    
    let name: String
    let type: String
    let description: String
    let required: Bool
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.description, forKey: .description)
    }
}

//MARK: - Function
public struct Function: Codable {
    
    let name: String
    let arguments: String
}
