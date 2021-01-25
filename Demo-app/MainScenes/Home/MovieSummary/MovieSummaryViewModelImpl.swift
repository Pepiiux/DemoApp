//
//  MovieSummaryViewModelImpl.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import RxSwift
import XCoordinator
import Action
import RxCocoa

class MovieSummaryViewModelImpl: MovieSummaryViewModel, MovieSummaryViewModelInput, MovieSummaryViewModelOutput {

    // MARK: - Inputs
    
    private(set) var tryFetchingReviewsTrigger: AnyObserver<Void>
    private(set) lazy var goBackTrigger: AnyObserver<Void> = goBackAction.inputs
    
    // MARK: - Outputs
    
    var isLoading: Observable<Bool>
    var errorMessage: Observable<String>
    var infoMessage: Observable<(String, String)>
    var movie: Observable<Movie>
    var reviews: Observable<[Review]>
    
    // MARK: - Actions
    
    private lazy var goBackAction = CocoaAction { [unowned self] in
        return self.router.rx.trigger(.goBack)
    }

    // MARK: - Private

    private let router: StrongRouter<HomeRoute>
    private let disposeBag = DisposeBag()
    
    // MARK: - Init

    init(router: StrongRouter<HomeRoute>, movie: Movie) {
        self.router = router
        
        let reviewsRepository = ReviewsRepository()
        
        self.movie = BehaviorSubject<Movie>(value: movie)
        
        let _reviews = PublishSubject<[Review]>()
        reviews = _reviews.asObservable()
        
        let _isLoadingSubject = PublishSubject<Bool>()
        isLoading = _isLoadingSubject.asObservable()

        let _errorMessage = PublishSubject<String>()
        errorMessage = _errorMessage.asObservable()

        let _infoMessage = PublishSubject<(String, String)>()
        infoMessage = _infoMessage.asObservable()
        
        let _tryFetchingReviews = PublishSubject<Void>()
        tryFetchingReviewsTrigger = _tryFetchingReviews.asObserver()
        
        let getReviewsRequestObservable = _tryFetchingReviews.asObservable()
            .flatMapLatest { _ -> Observable<Result<[Review], DemoAppError>> in
                return reviewsRepository.getReviews(withMovieId: movie.id)
            }.share()
        
        let getReviewsErrorObservable = getReviewsRequestObservable
            .filter { $0.isError }
            .map { $0.error! }
        
        getReviewsErrorObservable
            .map { error -> String in
                switch error {
                case .error(_, let message):
                    return message ?? "unexpectedError"
                default:
                    return "unexpectedError"
                }
            }.bind(to: _errorMessage.asObserver())
            .disposed(by: disposeBag)
        
        let getReviewsSuccessObservable = getReviewsRequestObservable
            .filter { $0.isSuccess }
            .map { $0.value! }
        
        getReviewsSuccessObservable
            .bind(to: _reviews)
            .disposed(by: disposeBag)
    }

}
