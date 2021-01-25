//
//  HomeViewModelImpl.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RxSwift
import XCoordinator
import CoreLocation
import RxCocoa
import Action


class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {

    // MARK: - Inputs

    private(set) var tryFetchingMoviesTrigger: AnyObserver<MoviesSortingCriteria>
    private(set) lazy var goToMovieSummaryTrigger: AnyObserver<Movie> = goToMovieSummaryAction.inputs
    
    // MARK: - Outputs
    
    var isLoading: Observable<Bool>
    var errorMessage: Observable<String>
    var infoMessage: Observable<(String, String)>
    var movies: Observable<[Movie]>
    var moviesSortingCriteria: Observable<MoviesSortingCriteria>
    
    // MARK: - Actions
    
    private lazy var goToMovieSummaryAction = Action<Movie, Void> { [unowned self] movie in
        self.router.rx.trigger(.movieSummary(movie: movie))
    }

    // MARK: - Private

    private let router: StrongRouter<HomeRoute>
    private let disposeBag = DisposeBag()
    private let _moviesSortingCriteria = BehaviorRelay<MoviesSortingCriteria>(value: .mostPopular)
    
    // MARK: - Init

    init(router: StrongRouter<HomeRoute>) {
        self.router = router
        
        let moviesRepository = MoviesRepository()
        
        let _isLoadingSubject = PublishSubject<Bool>()
        isLoading = _isLoadingSubject.asObservable()

        let _errorMessage = PublishSubject<String>()
        errorMessage = _errorMessage.asObservable()

        let _infoMessage = PublishSubject<(String, String)>()
        infoMessage = _infoMessage.asObservable()
        
        let _movies = PublishSubject<[Movie]>()
        movies = _movies.asObservable()
        
        moviesSortingCriteria = _moviesSortingCriteria.asObservable()
        
        let _tryFetchingMovies = PublishSubject<MoviesSortingCriteria>()
        tryFetchingMoviesTrigger = _tryFetchingMovies.asObserver()
        
        let getMoviesRequestObservable = _tryFetchingMovies.asObservable()
            .do(onNext: { _ in _isLoadingSubject.onNext(true) })
            .flatMapLatest { movieFilterType -> Observable<Result<[Movie], DemoAppError>> in
                return moviesRepository.getMovies(withFilter: movieFilterType)
            }
            .do(onNext: { _ in _isLoadingSubject.onNext(false) })
            .share()
        
        _tryFetchingMovies.asObservable()
            .bind(to: _moviesSortingCriteria)
            .disposed(by: disposeBag)
        
        let getMoviesErrorObservable = getMoviesRequestObservable
            .filter { $0.isError }
            .map { $0.error! }
        
        getMoviesErrorObservable
            .map { error -> String in
                switch error {
                case .error(_, let message):
                    return message ?? "unexpectedError"
                default:
                    return "unexpectedError"
                }
            }.bind(to: _errorMessage.asObserver())
            .disposed(by: disposeBag)
        
        let getMoviesSuccessObservable = getMoviesRequestObservable
            .filter { $0.isSuccess }
            .map { $0.value! }
        
        getMoviesSuccessObservable
            .bind(to: _movies)
            .disposed(by: disposeBag)
    }

}
