//
//  MoviesRequestHelper.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation

class MoviesRequestHelper: BaseRequestHelper<MoviesService> {

    // MARK: - Singleton

    static let sharedInstance = MoviesRequestHelper()

}
