//
//  SettingsCoordinator.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import XCoordinator
import RxSwift

enum SettingsRoute: Route {
    case settings
    case goBack
}

class SettingsCoordinator: BaseNavigationCoordinator<SettingsRoute> {

    // MARK: - Init

    init() {
        super.init(initialRoute: .settings, design: .light)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
        case .settings:
            let viewModel = SettingsViewModelImpl(router: strongRouter)
            let viewController = SettingsViewController(viewModel: viewModel)
            return .push(viewController)
        case .goBack:
            return .pop()
        }
    }

}
