//
//  UserDefault.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.11.2022.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    
    private(set) var storedValue: T?
    
    init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            guard storedValue == nil else { return storedValue }
            guard let object = UserDefaults.standard.object(forKey: key) as? T else { return defaultValue }
            return object
        }
        set {
            storedValue = newValue
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}
