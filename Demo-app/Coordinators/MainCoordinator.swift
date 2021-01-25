//
//  MainCoordinator.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import XCoordinator
import RxSwift
import EventKitUI

enum MainRoute: Route {
    // TabBar menu items
    case home
    case settings
}

class MainCoordinator: TabBarCoordinator<MainRoute> {

    // MARK: - Stored properties

    private let disposeBag = DisposeBag()
    private let homeRouter: StrongRouter<HomeRoute>
    private let settingsRouter: StrongRouter<SettingsRoute>


    // MARK: - Init

    convenience init() {
        let homeCoordinator = HomeCoordinator()
        let homeTabBarIcon = Images.home.withRenderingMode(.alwaysTemplate).withTintColor(Colors.customRed)
        homeCoordinator.rootViewController.tabBarItem = UITabBarItem(title: nil, image: homeTabBarIcon, selectedImage: homeTabBarIcon)
        
        let settingsCoordinator = SettingsCoordinator()
        let settingsTabBarIcon = Images.settings.withRenderingMode(.alwaysTemplate).withTintColor(Colors.customRed)
        settingsCoordinator.rootViewController.tabBarItem = UITabBarItem(title: nil, image: settingsTabBarIcon, selectedImage: settingsTabBarIcon)
        
        
        self.init(homeRouter: homeCoordinator.strongRouter, settingsRouter: settingsCoordinator.strongRouter)
    }

    init(homeRouter: StrongRouter<HomeRoute>, settingsRouter: StrongRouter<SettingsRoute>) {
        self.homeRouter = homeRouter
        self.settingsRouter = settingsRouter
        
        super.init(tabs: [homeRouter, settingsRouter], select: homeRouter)
        
        rootViewController.modalPresentationStyle = .fullScreen
        rootViewController.tabBar.isTranslucent = false
        rootViewController.tabBar.barTintColor = .white
        rootViewController.view.tintColor = Colors.customRed

    }

    // MARK: - Overrides

    override func prepareTransition(for route: MainRoute) -> TabBarTransition {
        switch route {
        case .home:
            return .select(homeRouter)
        case .settings:
            return .select(settingsRouter)
        }
    }

}
