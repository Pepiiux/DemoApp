//
//  Result+Additions.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Result

extension Result {

    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }

    var isError: Bool {
        return !isSuccess
    }

}
