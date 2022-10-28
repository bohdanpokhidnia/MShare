//
//  SceneDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainView: MainViewProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureNavigationBarStyle()
        configureTabBarStyle()
        
        mainView = MainRouter.createModule()
        
        #if DEV
        mainView?.selectedTab(.favorites)
        #endif
        
        if let url = connectionOptions.urlContexts.first?.url {
            handleIncomingURL(url)
        }
        
        window = UIWindow(windowScene: windowScene)
        #if DETAIL
        window?.rootViewController = DetailSongRouter.createModule(mediaResponse: NetworkService.MockData.songMediaResponse,
                                                                   cover: UIImage(named: "mockCover")!)
        #else
        window?.rootViewController = mainView?.viewController
        #endif
        window?.backgroundColor(color: .systemBackground)
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
        UINavigationBar.configure(style: .defaultBackground)
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
        
        mainView?.selectedTab(.link)
        UserDefaults().set(urlString, forKey: "incomingURL")
    }
    
}
