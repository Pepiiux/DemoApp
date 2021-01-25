//
//  MoviesRepository.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RxSwift
import Result

class MoviesRepository {
    
    // MARK: - Public methods to DB
    
    func getMovies(withFilter filterType: MoviesSortingCriteria) -> Observable<Result<[Movie], DemoAppError>> {
        let remoteMovies = getRemoteMovies(withFilter: filterType).filter({ $0.isError })
        let dbMovies = RealmManager.sharedInstance.getMovies()
        
        return Observable.merge(remoteMovies, dbMovies)
    }
    
    // MARK: - Private methods to Server
    
    func getRemoteMovies(withFilter filterType: MoviesSortingCriteria) -> Observable<Result<[Movie], DemoAppError>> {
        let moviesObservable: Observable<Result<[Movie], DemoAppError>>
        
        switch filterType {
        case .mostPopular:
            moviesObservable = MoviesRequestHelper.sharedInstance.performRequest(endpoint: .popular)
        case .topRated:
            moviesObservable = MoviesRequestHelper.sharedInstance.performRequest(endpoint: .top_rated)
        }
        
        return moviesObservable
            .flatMap { (result: Result<[Movie], DemoAppError>) -> Observable<Result<[Movie], DemoAppError>> in
                switch result.result {
                case .success(let movies):
                    return RealmManager.sharedInstance.saveMovies(movies).map { response in
                        switch response.result {
                        case .success():
                            return .success(movies)
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
