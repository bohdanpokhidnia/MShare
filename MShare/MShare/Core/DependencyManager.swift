//
//  DependencyManager.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 29.01.2023.
//

import Foundation

protocol DependencyManagerProtocol {
    func resolve<T>(type: T.Type) -> T
}

final class DependencyManager {
    static let shared = DependencyManager()
    
    func register<T>(type: T.Type, module: Any) {
        components["\(type)"] = module
    }
    
    // MARK: - Private
    
    private var components: [String: Any] = [:]
}

//MARK: - DependencyManagerProtocol

extension DependencyManager: DependencyManagerProtocol {
    func resolve<T>(type: T.Type) -> T {
        let module = components["\(type)"] as! T
        return module
    }
}
