//
//  AppRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 14.04.2024.
//

import UIKit

protocol AppRouterProtocol {
    func launchApplication()
    func loadOnboarding()
    func loadMain()
    func select(mainTab: MainEntity.TabItem)
}

final class AppRouter: Router {
    // MARK: - Initializers
    
    init(
        dependencyManager: DependencyManagerProtocol,
        window: UIWindow?
    ) {
        self.window = window
        
        super.init(dependencyManager: dependencyManager)
    }
    
    // MARK: - Private
    
    private var window: UIWindow?
    private var mainRouter: MainRouter?
}

// MARK: - Private Methods

private extension AppRouter {
    func load(router: Router) {
        let viewController = router.createModule()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

//MARK: - AppRouterProtocol

extension AppRouter: AppRouterProtocol {
    func launchApplication() {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        let isDisplayOnboarding = userManager.isDisplayOnboarding ?? false
        
        if isDisplayOnboarding {
            loadMain()
        } else {
            loadOnboarding()
        }
    }
    
    func loadOnboarding() {
        let onboardingRouter = OnboardingRouter(
            appRouter: self,
            dependencyManager: dependencyManager
        )
        load(router: onboardingRouter)
    }
    
    func loadMain() {
        let mainRouter = MainRouter(dependencyManager: dependencyManager)
        self.mainRouter = mainRouter
        load(router: mainRouter)
        mainRouter.select(tab: .link)
    }
    
    func select(mainTab: MainEntity.TabItem) {
        mainRouter?.select(tab: mainTab)
    }
}
