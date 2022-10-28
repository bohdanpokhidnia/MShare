//
//  DatabaseManager.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation
import RealmSwift

protocol DatabaseManagerBaseProtocol {
    func save(_ object: Object, update: Realm.UpdatePolicy?, completionHandler: DatabaseManager.CompletionHandler)
    func save(_ object: Object, completionHandler: @escaping DatabaseManager.CompletionHandler)
    func save<S: Sequence>(_ objects: S, completionHandler: DatabaseManager.CompletionHandler) where S.Iterator.Element: Object

    func delete(_ object: Object, completionHandler: DatabaseManager.CompletionHandler)
    func drop<T: Object>(_ classType: T.Type, completionHandler: DatabaseManager.CompletionHandler)

    func getObject<T: Object, K>(_ classType: T.Type, forPrimaryKey: K) -> T?
    func getObjects<T: RealmFetchable>(_ classType: T.Type) -> [T]
    func getObjects<T: RealmFetchable>(_ classType: T.Type, filter: String) -> [T]

    func write(actionHandler: DatabaseManager.ActionHandler, completionHandler: DatabaseManager.CompletionHandler)
}

protocol DatabaseManagerMediaProtocol {
    
}

typealias DatabaseManagerProtocol = DatabaseManagerBaseProtocol & DatabaseManagerMediaProtocol

final class DatabaseManager {
    typealias CompletionHandler = ((_ error: DBError?) -> Void)
    typealias ActionHandler = (() -> Void)

    internal lazy var realm: Realm = {
        let actualSchemaVersion: UInt64 = 1

        let configuration = Realm.Configuration(schemaVersion: actualSchemaVersion) { (migration, oldSchemaVersion) in
            if oldSchemaVersion < actualSchemaVersion {
                
            }
        }

        let realm = try! Realm(configuration: configuration)
        return realm
    }()
}
