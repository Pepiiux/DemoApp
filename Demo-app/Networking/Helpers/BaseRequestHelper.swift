//
//  BaseRequestHelper.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import Moya
import RxSwift
import Result

let validRequestStatusCodes = 200...299

enum ApiVersion: String {
    case none = ""
    case v3 = "3"
}

class BaseRequestHelper<A: TargetType> {
    
    // MARK: - Provider

    fileprivate var provider: MoyaProvider<A>

    init() {
        let endpointClosure = { (target: A) -> Endpoint in
            let defaultEndpoint = Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
            
            return defaultEndpoint
        }

        let stubClosure = { (target: A) -> StubBehavior in
            return .never
        }
        
        let networkLogginPlugin = NetworkLoggerPlugin(verbose: true)
        provider = MoyaProvider<A>.init(endpointClosure: endpointClosure, stubClosure: stubClosure, plugins: [networkLogginPlugin])
    }

    // MARK: - Requests

    func performRequest<T: Decodable>(endpoint: A) -> Observable<Result<T, DemoAppError>> {
        return provider.rx.request(endpoint).map { response in
            let data = response.data

            guard validRequestStatusCodes.contains(response.statusCode) else {
                return .failure(.error(response.statusCode, "Bad Request."))
            }
            
            do {
                let responseDecoded = try JSONDecoder().decode(Response<T>.self, from: data)
                guard let dataDecoded = responseDecoded.data else {
                    return .failure(.error(DemoAppError.errorDecodableResult, "Data decode error."))
                }
                
                return .success(dataDecoded)
            } catch _ {
                return .failure(.error(DemoAppError.errorDecodableResult, "Response decode error."))
            }
        }.asObservable()
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .catchErrorJustReturn(.failure(DemoAppError.unexpectedError))
    }

}
