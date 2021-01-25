//
//  DemoAppError.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation

enum DemoAppError: Error, Equatable {

    case error(Int, String?)
    case couldNotOpenRealm
    case objectHasNoPrimaryKey
    case objectNotFoundByPrimaryKey
    case primaryKeyTypeNotSupported
    case unexpectedError
    case wrongPassword
    case forceLogout
    case noInternetConnection

    // Error codes

    static let errorDecodableResult = 300
}
