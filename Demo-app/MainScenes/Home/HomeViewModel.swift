//
//  HomeViewModel.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RxSwift
import XCoordinator

protocol HomeViewModelInput {
    var tryFetchingMoviesTrigger: AnyObserver<MoviesSortingCriteria> { get }
    var goToMovieSummaryTrigger: AnyObserver<Movie> { get }
}

protocol HomeViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var errorMessage: Observable<String> { get }
    var infoMessage: Observable<(String, String)> { get }
    var movies: Observable<[Movie]> { get }
    var moviesSortingCriteria: Observable<MoviesSortingCriteria> { get }
}

protocol HomeViewModel {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

extension HomeViewModel where Self: HomeViewModelInput & HomeViewModelOutput {
    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }
}
