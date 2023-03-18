//
//  Router.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.03.2023.
//

import UIKit

class Router {
    let dependencyManager: DependencyManagerProtocol
    
    init(dependencyManager: DependencyManagerProtocol) {
        self.dependencyManager = dependencyManager
    }
    
    func createModule() -> UIViewController {
        return .init()
    }
}
