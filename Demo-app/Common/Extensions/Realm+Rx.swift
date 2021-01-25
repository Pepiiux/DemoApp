//
//  Realm+Rx.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RealmSwift
import RxSwift
import Realm


extension Reactive where Base == Realm {
    func save<R: Object>(entities: [R], update: Realm.UpdatePolicy = .modified) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entities.mapToDetached(), update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func save<R: Object>(entity: R, update: Realm.UpdatePolicy = .modified) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entity.detached(), update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func delete<R: Object>(entity: R, primaryKey: String) -> Observable<Void> {
        return Observable.create { observer in
            do {
                if let object = self.base.object(ofType: R.self, forPrimaryKey: primaryKey) {

                    try self.base.write {
                        self.base.delete(object)
                    }

                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(DemoAppError.objectNotFoundByPrimaryKey)
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func deleteObjects<R: Object>(entityType: R.Type) -> Observable<Void> {
        return Observable.create { observer in
            do {
                let objects = self.base.objects(entityType)
                
                try self.base.write {
                    self.base.delete(objects)
                }

                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }

    func deleteAll() -> Observable<Void> {
        return Observable.create { observer in
            do {

                try self.base.write {
                    self.base.deleteAll()
                }

                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

}
