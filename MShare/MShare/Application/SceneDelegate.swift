//
//  SceneDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var dependencyManager = DependencyManager.shared
    private var appRouter: AppRouter?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        configureTabBarStyle()
        registerDependecies()
        launchApplication(for: windowScene, options: connectionOptions)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        handleIncomingURL(url)
    }
}

// MARK: - Setup Configuration

private extension SceneDelegate {
    func configureTabBarStyle() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

// MARK: - Register dependencies

private extension SceneDelegate {
    func registerDependecies() {
        let userManager = UserManager()
        let databaseManager = DatabaseManager()
        let apiClient = ApiClient()
        let factory = Factory()
        
        dependencyManager.register(type: DatabaseManagerProtocol.self, module: databaseManager)
        dependencyManager.register(type: UserManagerProtocol.self, module: userManager)
        dependencyManager.register(type: ApiClient.self, module: apiClient)
        dependencyManager.register(type: FactoryProtocol.self, module: factory)
    }
}

// MARK: - Load main screen

private extension SceneDelegate {
    func launchApplication(for scene: UIWindowScene, options: UIScene.ConnectionOptions) {
        window = UIWindow(windowScene: scene)
        
        appRouter = AppRouter(dependencyManager: dependencyManager, window: window)
        appRouter?.launchApplication()
        
        if let url = options.urlContexts.first?.url {
            handleIncomingURL(url)
        }
    }
}

// MARK: - Link handling

private extension SceneDelegate {
    func handleIncomingURL(_ url: URL) {
        guard let scheme = url.scheme else {
            return
        }
        guard scheme.caseInsensitiveCompare("ShareExtension") == .orderedSame else {
            return
        }
        var parameters: [String: String] = [:]
        
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        
        guard let urlString = parameters["url"] else {
            return
        }
        
        appRouter?.dismissPresentedViewController(animated: true) { [weak self] in
            self?.selectLinkTab(with: urlString)
        }
    }
    
    func selectLinkTab(with urlString: String) {
        appRouter?.select(mainTab: .link)
        
        UserDefaults().set(urlString, forKey: "incomingURL")
    }
}
