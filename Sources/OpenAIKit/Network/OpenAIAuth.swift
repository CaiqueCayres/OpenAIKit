//
//  File.swift
//  
//
//  Created by Carlos Cayres on 28/07/23.
//

import Foundation

/// Represents OpenAI API authentication information.
///
/// This struct is used to store base URL and header information
/// required for API requests to the OpenAI API.
public struct OpenAIAuth {
    
    /// The base URL for the OpenAI API.
    var baseUrl: String
    
    /// The headers for the OpenAI API, including the bearer token for authorization.
    var baseHeader: [String : String]
    
    /// Creates a new `OpenAIAuth` instance.
    ///
    /// This initializer sets up the base URL and headers for API requests.
    ///
    /// - Parameter token: The bearer token to be used for authorization with the OpenAI API.
    init(token: String) {
        self.baseUrl = "https://api.openai.com"
        self.baseHeader = ["content-type":"application/json",
                           "Authorization": "Bearer " + token]
    }
}

