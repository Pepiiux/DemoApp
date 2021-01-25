//
//  ReviewsRepository.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import RxSwift
import Result

class ReviewsRepository {
    
    // MARK: - Public methods to DB
    
    func getReviews(withMovieId id: Int) -> Observable<Result<[Review], DemoAppError>> {
        let remoteReviews = getRemoteReviews(withMovieId: id).filter({ $0.isError })
        let dbReviews = RealmManager.sharedInstance.getReviews()
        
        return Observable.merge(remoteReviews, dbReviews)
    }
    
    // MARK: - Private methods to Server
    
    func getRemoteReviews(withMovieId id: Int) -> Observable<Result<[Review], DemoAppError>> {
        let reviewsObservable: Observable<Result<[Review], DemoAppError>> = ReviewsRequestHelper.sharedInstance.performRequest(endpoint: .reviews(movieId: id))
        
        return reviewsObservable
            .flatMap { (result: Result<[Review], DemoAppError>) -> Observable<Result<[Review], DemoAppError>> in
                switch result.result {
                case .success(let reviews):
                    return RealmManager.sharedInstance.saveReviews(reviews).map { response in
                        switch response.result {
                        case .success():
                            return .success(reviews)
                        case .failure:
                            return .failure(.unexpectedError)
                        }
                    }
                case .failure:
                    return .just(.failure(.unexpectedError))
                }
            }
    }
    
}
