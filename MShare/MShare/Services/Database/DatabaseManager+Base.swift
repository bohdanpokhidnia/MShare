//
//  DatabaseManager+Base.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation
import RealmSwift

// MARK: - DatabaseManagerBaseProtocol

extension DatabaseManager: DatabaseManagerBaseProtocol {

    func save(_ object: Object, update: Realm.UpdatePolicy?, completionHandler: CompletionHandler) {
        guard !object.isInvalidated else {
            completionHandler(.isInvalidate)
            return
        }

        do {
            try realm.write {
                if let update = update {
                    realm.add(object, update: update)
                } else {
                    realm.add(object)
                }

                completionHandler(nil)
            }
        } catch {
            completionHandler(.other(error))
        }
    }

    func save(_ object: Object, completionHandler: @escaping CompletionHandler) {
        save(object, update: nil, completionHandler: completionHandler)
    }

    func save<S: Sequence>(_ objects: S, completionHandler: (DBError?) -> Void) where S.Element: Object {
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch {
            completionHandler(.other(error))
        }

        completionHandler(nil)
    }

    func delete(_ object: Object, completionHandler: CompletionHandler) {
        guard !object.isInvalidated else {
            completionHandler(.isInvalidate)

            return
        }

        do {
            try realm.write {
                realm.delete(object)
                completionHandler(nil)
            }
        } catch {
            completionHandler(.other(error))
        }
    }

    func drop<T: Object>(_ classType: T.Type, completionHandler: (DBError?) -> Void) {
        let objects = getObjects(classType)

        do {
            try realm.write {
                realm.delete(objects)
                completionHandler(nil)
            }
        } catch {
            completionHandler(.other(error))
        }
    }

    func getObject<T: Object, K>(_ classType: T.Type, forPrimaryKey: K) -> T? {
        let object = realm.object(ofType: classType.self, forPrimaryKey: forPrimaryKey)

        guard !(object?.isInvalidated ?? true) else {
            return nil
        }

        return object
    }

    func getObjects<T: RealmFetchable>(_ classType: T.Type) -> [T] {
        let objects = Array(realm.objects(classType))
        return objects
    }

    func getObjects<T: RealmFetchable>(_ classType: T.Type, filter: String) -> [T] {
        let objects = realm.objects(classType)
        let filteredObjects = Array(objects.filter(filter))

        return filteredObjects
    }

    func write(actionHandler: ActionHandler, completionHandler: CompletionHandler) {
        do {
            try realm.write {
                actionHandler()
            }
        } catch {
            completionHandler(.other(error))
        }

        completionHandler(nil)
    }

}

