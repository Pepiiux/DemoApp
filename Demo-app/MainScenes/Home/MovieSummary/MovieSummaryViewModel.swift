//
//  MovieSummaryViewModel.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import RxSwift
import XCoordinator

protocol MovieSummaryViewModelInput {
    var tryFetchingReviewsTrigger: AnyObserver<Void> { get }
    var goBackTrigger: AnyObserver<Void> { get }
}

protocol MovieSummaryViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var errorMessage: Observable<String> { get }
    var infoMessage: Observable<(String, String)> { get }
    var movie: Observable<Movie> { get }
    var reviews: Observable<[Review]> { get }
}

protocol MovieSummaryViewModel {
    var input: MovieSummaryViewModelInput { get }
    var output: MovieSummaryViewModelOutput { get }
}

extension MovieSummaryViewModel where Self: MovieSummaryViewModelInput & MovieSummaryViewModelOutput {
    var input: MovieSummaryViewModelInput { return self }
    var output: MovieSummaryViewModelOutput { return self }
}
