//
//  MoviesService.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import Moya

enum MoviesService {
    case popular
    case top_rated
}

extension MoviesService: TargetType {
    
    var apiVersion: ApiVersion { return .v3 }

    var baseURL: URL { return URL(string: ConfigurationManager.sharedInstance.serverBaseURL + apiVersion.rawValue)! }

    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .top_rated:
            return "/movie/top_rated"
        }
    }

    var method: Moya.Method {
        switch self {
        case .popular, .top_rated:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .popular, .top_rated:
            return .requestParameters(parameters: ["api_key": ConfigurationManager.sharedInstance.apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .popular, .top_rated:
            return "".data(using: String.Encoding.utf8)!
        }
    }

    var headers: [String : String]? {
        switch self {
        case .popular, .top_rated:
            return nil
        }
    }

}
