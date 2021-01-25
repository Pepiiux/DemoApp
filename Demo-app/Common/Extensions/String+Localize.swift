//
//  String+Localize.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation

extension String {

    public func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }

}
