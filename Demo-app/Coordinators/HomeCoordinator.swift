//
//  HomeCoordinator.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import XCoordinator
import RxSwift
import SafariServices
import EventKitUI

enum HomeRoute: Route {
    case home
    case movieSummary(movie: Movie)
    case goBack
    case none
}

class HomeCoordinator: BaseNavigationCoordinator<HomeRoute> {

    // MARK: - Properties

    private var homeViewModel: HomeViewModel!
    private var homeViewController: HomeViewController!

    // MARK: - Init

    init() {
        super.init(initialRoute: .home, design: .light)
    }

    // MARK: - Overrides

    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .home:
            homeViewModel = HomeViewModelImpl(router: strongRouter)
            homeViewController = HomeViewController(viewModel: homeViewModel)
            return .set([homeViewController])
        case .movieSummary(let movie):
            let viewModel = MovieSummaryViewModelImpl(router: strongRouter, movie: movie)
            let viewController = MovieSummaryViewController(viewModel: viewModel)
            return .push(viewController)
        case .goBack:
            return .pop()
        case .none:
            return .none()
        }
    }

}
