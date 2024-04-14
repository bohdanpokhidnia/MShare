//
//  Router.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.03.2023.
//

import UIKit

class Router {
    let appRouter: AppRouterProtocol?
    let dependencyManager: DependencyManagerProtocol
    
    init(
        appRouter: AppRouterProtocol? = nil,
        dependencyManager: DependencyManagerProtocol
    ) {
        self.appRouter = appRouter
        self.dependencyManager = dependencyManager
    }
    
    func createModule() -> UIViewController {
        return .init()
    }
}
