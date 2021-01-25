//
//  ShadowedView.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import UIKit

class ShadowedView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        super.dropShadow()
    }

}
