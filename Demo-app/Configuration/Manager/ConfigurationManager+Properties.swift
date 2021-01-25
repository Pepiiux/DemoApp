//
//  ConfigurationManager+Properties.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation

extension ConfigurationManager {

    static var environment: Environment {
        return Environment(rawValue: ConfigurationManager.currentConfiguration as! String)!
    }

    var serverBaseURL: String {
        return configs["SERVER_BASE_URL"]!
    }

    var apiKey: String {
        return configs["API_KEY"]!
    }
    
    var imageBaseURL: String {
        return configs["IMAGE_BASE_URL"]!
    }
    
}
