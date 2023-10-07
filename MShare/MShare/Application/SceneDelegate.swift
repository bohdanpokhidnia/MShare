//
//  SceneDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var dependencyManager = DependencyManager()
    private var onboardingRouter: UIViewController?
    private var mainRouter: MainViewProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureNavigationBarStyle()
        configureTabBarStyle()
        registerDependecies()
        loadMainScreen(for: windowScene, options: connectionOptions)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        handleIncomingURL(url)
    }
    
}

// MARK: - Setup Configuration

private extension SceneDelegate {
    
    func configureNavigationBarStyle() {
        UINavigationBar.configure(style: .transcelent)
    }
    
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
    func loadMainScreen(for scene: UIWindowScene, options: UIScene.ConnectionOptions) {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        
        let displayOnboarding = userManager.displayOnboarding ?? false
        
        onboardingRouter = OnboardingRouter(dependencyManager: dependencyManager).createModule()
        mainRouter = MainRouter(dependencyManager: dependencyManager).initMainModule()
        
        #if DEV
        mainRouter?.selectTab(.link)
        #else
        main?.selectTab(.link)
        #endif
        
        if let url = options.urlContexts.first?.url {
            handleIncomingURL(url)
        }
        
        window = UIWindow(windowScene: scene)
        
        #if DETAIL
        let detailScreen = DetailSongRouter(
            dependencyManager: dependencyManager,
            mediaResponse: MockData.songMediaResponse,
            cover: UIImage(named: "mockCover")!
        ).createModule()
        window?.rootViewController = AppNavigationController(rootViewController: detailScreen)
        #else
        window?.rootViewController = displayOnboarding ? mainRouter?.viewController : onboardingRouter
        #endif
        
        window?.backgroundColor(color: displayOnboarding ? .systemBackground : .black)
        window?.makeKeyAndVisible()
    }
}

// MARK: - Link handling

private extension SceneDelegate {
    
    func handleIncomingURL(_ url: URL) {
        guard let scheme = url.scheme,
              scheme.caseInsensitiveCompare("ShareExtension") == .orderedSame
        //TODO: - For select tab in future
        //let page = url.host
        else { return }
        var parameters: [String: String] = [:]
        
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        
        guard let urlString = parameters["url"] else { return }
        
        if let detailSongView = mainRouter?.viewController.topMostViewController as? DetailSongView {
            detailSongView.navigationController?.popViewController(animated: true) { [weak self] in
                self?.selectLinkTab(withUrlString: urlString)
            }
        } else {
            selectLinkTab(withUrlString: urlString)
        }
    }
    
    func selectLinkTab(withUrlString urlString: String) {
        mainRouter?.selectTab(.link)
        
        UserDefaults().set(urlString, forKey: "incomingURL")
    }
    
}
