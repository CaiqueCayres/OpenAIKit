//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

public struct OpenAIAuth {
    
    var baseUrl: String
    var baseHeader: [String : String]
    
    init(token: String) {
        self.baseUrl = "https://api.openai.com"
        self.baseHeader = ["content-type":"application/json",
                           "Authorization": "Bearer " + token]
    }
}
