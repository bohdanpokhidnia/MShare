//
//  SceneDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var userManager = UserManager()
    private lazy var databaseManager = DatabaseManager()
    private lazy var apiClient = ApiClient()
    private lazy var factory = Factory()
    
    var onboarding: UIViewController?
    var main: MainViewProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureNavigationBarStyle()
        configureTabBarStyle()
        
        let dependencyManager = DependencyManager()
        dependencyManager.register(type: DatabaseManagerProtocol.self, module: databaseManager)
        dependencyManager.register(type: UserManagerProtocol.self, module: userManager)
        dependencyManager.register(type: ApiClient.self, module: apiClient)
        dependencyManager.register(type: FactoryProtocol.self, module: factory)
        
        let displayOnboarding = userManager.displayOnboarding ?? false
        
        onboarding = OnboardingRouter(dependencyManager: dependencyManager).createModule()
        main = MainRouter(dependencyManager: dependencyManager).initMainModule()
        
        #if DEV
        main?.selectedTab(.link)
        #else
        main?.selectedTab(.link)
        #endif
        
        if let url = connectionOptions.urlContexts.first?.url {
            handleIncomingURL(url)
        }
        
        window = UIWindow(windowScene: windowScene)
        
        #if DETAIL
        let detailScreen = DetailSongRouter(
            dependencyManager: dependencyManager,
            mediaResponse: MockData.songMediaResponse,
            cover: UIImage(named: "mockCover")!
        ).createModule()
        window?.rootViewController = AppNavigationController(rootViewController: detailScreen)
        #else
        window?.rootViewController = displayOnboarding ? main?.viewController : onboarding
        #endif
        
        window?.backgroundColor(color: displayOnboarding ? .systemBackground : .black)
        window?.makeKeyAndVisible()
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
        
        if let detailSongView = main?.viewController.topMostViewController as? DetailSongView {
            detailSongView.navigationController?.popViewController(animated: true) { [weak self] in
                self?.selectLinkTab(withUrlString: urlString)
            }
        } else {
            selectLinkTab(withUrlString: urlString)
        }
    }
    
    func selectLinkTab(withUrlString urlString: String) {
        main?.selectedTab(.link)
        
        UserDefaults().set(urlString, forKey: "incomingURL")
    }
    
}
