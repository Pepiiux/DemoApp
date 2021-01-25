//
//  FilterMoviesHelper.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation

enum MoviesSortingCriteria {

    case mostPopular
    case topRated

    var title: String {
        switch self {
        case .mostPopular:
            return "Most popular".localize()
        case .topRated:
            return "Top rated".localize()
        }
    }

    static func getAll() -> [MoviesSortingCriteria] {
        return [.mostPopular, .topRated]
    }

}
