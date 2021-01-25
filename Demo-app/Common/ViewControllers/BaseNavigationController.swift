//
//  BaseNavigationController.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - Device Orientation

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        guard let topViewController = topViewController else {
            return .portrait
        }

        return topViewController.supportedInterfaceOrientations
    }

    override var shouldAutorotate : Bool {
        guard let topViewController = topViewController else {
            return true
        }

        return topViewController.shouldAutorotate
    }

}
