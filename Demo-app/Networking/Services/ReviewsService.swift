//
//  ReviewsService.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import Moya

enum ReviewsService {
    case reviews(movieId: Int)
}

extension ReviewsService: TargetType {
    
    var apiVersion: ApiVersion { return .v3 }

    var baseURL: URL { return URL(string: ConfigurationManager.sharedInstance.serverBaseURL + apiVersion.rawValue)! }

    var path: String {
        switch self {
        case .reviews(let movieId):
            return "/movie/\(movieId)/reviews"
        }
    }

    var method: Moya.Method {
        switch self {
        case .reviews:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .reviews:
            return .requestParameters(parameters: ["api_key": ConfigurationManager.sharedInstance.apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .reviews:
            return "".data(using: String.Encoding.utf8)!
        }
    }

    var headers: [String : String]? {
        switch self {
        case .reviews:
            return nil
        }
    }

}
