//
//  ConfigurationManager.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation

class ConfigurationManager: NSObject {

    enum Environment: String {
        case development = "Debug"
        case testing = "Testing"
        case production = "Release"
    }

    static let sharedInstance = ConfigurationManager()

    var configs: [String: String]!

    static let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!

    override init() {
        if let url = Bundle.main.url(forResource: "Configuration-\(ConfigurationManager.currentConfiguration)", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                configs = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String]
            } catch {
                print(error)
            }
        }
    }

}
