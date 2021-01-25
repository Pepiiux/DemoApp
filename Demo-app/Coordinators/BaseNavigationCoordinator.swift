//
//  BaseNavigationCoordinator.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import XCoordinator

enum NavigationCoordinatorDesign {
    case light
    case dark
    case none
}

class BaseNavigationCoordinator<T: Route>: NavigationCoordinator<T> {
    
    init(initialRoute route: RouteType, design: NavigationCoordinatorDesign) {
        super.init(initialRoute: route)
        
        rootViewController.modalPresentationStyle = .fullScreen
        
        switch design {
        case .light:
            rootViewController.setClearDesign()
        case .dark:
            rootViewController.setDarkDesign()
        case .none:
            rootViewController.setNoNavigationDesign()
        }
        
    }
    
}
