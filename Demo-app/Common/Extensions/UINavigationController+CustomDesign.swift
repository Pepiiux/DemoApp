//
//  UINavigationController+CustomDesign.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import UIKit

extension UINavigationController {

    func setDarkDesign() {
        navigationBar.barTintColor = .black
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.gray
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
    }

    func setClearDesign() {
        navigationBar.barTintColor = .clear
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    func setNoNavigationDesign() {
        self.setNavigationBarHidden(true, animated: false)
    }

}
