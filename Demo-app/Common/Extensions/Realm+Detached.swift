//
//  Realm+Detached.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RealmSwift
import RxSwift
import Realm

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {

    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }

            if property.isArray == true || property.type == .object {
                let detachable = value as? DetachableObject
                detached.setValue(detachable?.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

extension List: DetachableObject {

    func detached() -> List<Element> {
        let result = List<Element>()

        forEach {
            if let detachable = $0 as? DetachableObject {
                let detached = detachable.detached() as! Element
                result.append(detached)
            } else {
                result.append($0)
            }
        }

        return result
    }

    func toArray() -> [Element] {
        return Array(self.detached())
    }

}

extension Results where Element: Object {

    func detachedArray() -> [Element] {
        let result = List<Element>()

        forEach {
            result.append($0.detached())
        }

        return Array(result)
    }

}

extension Observable where Element: Sequence, Element.Iterator.Element: Object {
    typealias T = Element.Iterator.Element

    func mapToDetached() -> Observable<[T]> {
        return map { sequence -> [T] in
            return sequence.mapToDetached()
        }
    }
}

extension Sequence where Iterator.Element: Object {
    typealias Element = Iterator.Element

    func mapToDetached() -> [Element] {
        return map {
            return $0.detached()
        }
    }
}
