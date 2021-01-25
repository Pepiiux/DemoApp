//
//  AppCoordinator.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import XCoordinator
import RxSwift
import Action

enum AppRoute: Route {
    case main
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    // We need to keep a reference to the MainCoordinator
    // as it is not held by any viewModel or viewController
    private var main: Presentable?
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        super.init(initialRoute: .main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .main:
            var presentable: Presentable
            presentable = MainCoordinator()
            self.main = presentable
            
            return .presentOnRoot(presentable)
        }
    }
    
}
