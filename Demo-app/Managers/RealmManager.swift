//
//  RealmManager.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RealmSwift
import RxSwift
import Result
import RxRealm

class RealmManager {

    // MARK: - Singleton

    static let sharedInstance = RealmManager()

    // MARK: Properties

    private let scheduler: RunLoopThreadScheduler
    private var realm: Realm {
        return try! Realm()
    }

    init() {
        let name = "com.demoApp.Managers.RealmManager"
        self.scheduler = RunLoopThreadScheduler(threadName: name)
        setupDefaultConfiguration()
        setupEncription()
    }

    // MARK: - Private methods

    private func setupDefaultConfiguration() {
        // Increment version +1 when realm objects were update for new fields or dataTypes updates
        var config = Realm.Configuration(schemaVersion: Constants.realmSchemaVersion)

        // Use the default directory, but replace the filename with the app name
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("demoApp.realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    private func setupEncription() {

        // Get our Realm file's parent directory
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path

        // Disable file protection for this directory
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey : FileProtectionType.none],
                                               ofItemAtPath: folderPath)
    }
    
    // MARK: -  Get movies objects
    
    func getMovies() -> Observable<Result<[Movie], DemoAppError>> {
        let queryMovies: Observable<[Movie]> = queryAll()

        return queryMovies.map {
            return Result<[Movie], DemoAppError>.success($0)
        }.catchError { (error) -> Observable<Result<[Movie], DemoAppError>> in
            if let error = error as? DemoAppError {
                return .just(Result<[Movie], DemoAppError>.failure(error))
            } else {
                return .just(Result<[Movie], DemoAppError>.failure(.unexpectedError))
            }
        }
    }
    
    // MARK: -  Get reviews objects
    
    func getReviews() -> Observable<Result<[Review], DemoAppError>> {
        let queryReviews: Observable<[Review]> = queryAll()

        return queryReviews.map {
            return Result<[Review], DemoAppError>.success($0)
        }.catchError { (error) -> Observable<Result<[Review], DemoAppError>> in
            if let error = error as? DemoAppError {
                return .just(Result<[Review], DemoAppError>.failure(error))
            } else {
                return .just(Result<[Review], DemoAppError>.failure(.unexpectedError))
            }
        }
    }
    
    // MARK: -  Save movies objects
    
    func saveMovies(_ movies: [Movie]) -> Observable<Result<Void, DemoAppError>> {
        let queryMovies: Observable<[Movie]> = queryAll().take(1)
        return queryMovies.flatMapLatest { [weak self] currentMovies -> Observable<Result<Void, DemoAppError>> in
            guard let strongSelf = self else {
                return .just(.failure(.unexpectedError))
            }
            
            let moviesToRemove = currentMovies.filter { currentMovie in
                return !movies.contains { $0.id == currentMovie.id }
            }
            
            moviesToRemove.forEach { [weak self] movie in
                self?.deleteObject(entity: movie, primaryKey: movie.id)
            }
            
            return strongSelf.save(entities: movies).map {
                return Result<Void, DemoAppError>.success(())
            }.catchErrorJustReturn(Result<Void, DemoAppError>.failure(.unexpectedError))
        }
    }
    
    // MARK: -  Save reviews objects
    
    func saveReviews(_ reviews: [Review]) -> Observable<Result<Void, DemoAppError>> {
        let queryReviews: Observable<[Review]> = queryAll().take(1)
        return queryReviews.flatMapLatest { [weak self] currentReviews -> Observable<Result<Void, DemoAppError>> in
            guard let strongSelf = self else {
                return .just(.failure(.unexpectedError))
            }
            
            let reviewsToRemove = currentReviews.filter { currentReview in
                return !reviews.contains { $0.id == currentReview.id }
            }
            
            reviewsToRemove.forEach { [weak self] review in
                self?.deleteObject(entity: review, primaryKey: review.id)
            }
            
            return strongSelf.save(entities: reviews).map {
                return Result<Void, DemoAppError>.success(())
            }.catchErrorJustReturn(Result<Void, DemoAppError>.failure(.unexpectedError))
        }
    }
    
    // MARK: - Actions
    
    func queryAll<T:Object>() -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.self)

            return Observable.array(from: objects).mapToDetached()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    func query<T:Object>(with predicate: NSPredicate,
                         sortDescriptors: [SortDescriptor] = []) -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.self)
            .filter(predicate)
            .sorted(by: sortDescriptors)
            return Observable.array(from: objects).mapToDetached()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    func query<T:Object>(primaryKey: Any) -> Observable<T?> {
        return Observable.deferred {
            guard let primaryKeyName = T.primaryKey() else {
                return .just(nil)
            }
            
            var predicate: NSPredicate = NSPredicate()
            if let primaryKeyStringValue = primaryKey as? String {
                predicate = NSPredicate(format: "%K = '%@'", primaryKeyName, primaryKeyStringValue)
            } else if let primaryKeyIntValue = primaryKey as? Int {
                predicate = NSPredicate(format: "%K = %i", primaryKeyName, primaryKeyIntValue)
            }
            
            return self.query(with: predicate)
                .map { $0.first }
        }.subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    func save<T:Object>(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entity: entity)
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    func save<T:Object>(entities: [T], update: Realm.UpdatePolicy = .modified) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entities: entities, update: update)
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    func delete<T:Object>(entity: T, primaryKey: String) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity: entity, primaryKey: primaryKey)
        }.subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    func deleteObject<T:Object>(entity: T, primaryKey: Any) {
        do {
            if let object = self.realm.object(ofType: T.self, forPrimaryKey: primaryKey) {
                try self.realm.write {
                    self.realm.delete(object)
                }
            } else {
                return
            }
        } catch {
            return
        }
    }

    func deleteAll() -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.deleteAll()
        }.subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

}
