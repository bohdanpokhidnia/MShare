//
//  SettingsRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SafariServices

protocol SettingsRouterProtocol: ModuleRouterProtocol {
    func pushAboutUsScreen(from view: SettingsViewProtocol?)
    func presentBrowserScreen(from view: SettingsViewProtocol?, forUrlString urlString: String)
    func pushFirstFavoritesScreen(fromView view: SettingsViewProtocol?, favoriteSectionIndex: Int, firstFavoritesDelegate: FirstFavoritesDelegate)
    func pushSystemSettings()
    func showOnboarding()
}

final class SettingsRouter: SettingsRouterProtocol {
    
    static func createModule() -> UIViewController {
        @Inject var userManager: UserManagerProtocol
        
        let view: SettingsViewProtocol = SettingsView()
        let presenter: SettingsPresenterProtocol & SettingsInteractorOutputProtocol = SettingsPresenter()
        var interactor: SettingsInteractorIntputProtocol = SettingsInteractor(userManager: userManager)
        let router = SettingsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
    func createModule() -> UIViewController {
        return SettingsRouter.createModule()
    }
    
    func pushAboutUsScreen(from view: SettingsViewProtocol?) {
        let aboutUs = AboutUsView()
            .make { $0.hidesBottomBarWhenPushed = true }
        
        view?.viewController.navigationController?.pushViewController(aboutUs, animated: true)
    }
    
    func presentBrowserScreen(from view: SettingsViewProtocol?, forUrlString urlString: String) {
        let safariViewController = SFSafariViewController(url: URL(string: urlString)!)
        
        view?.viewController.present(safariViewController, animated: true)
    }
    
    func pushFirstFavoritesScreen(fromView view: SettingsViewProtocol?, favoriteSectionIndex: Int, firstFavoritesDelegate: FirstFavoritesDelegate) {
        let firstFavoriritesView = FirstFavoritesView()
            .make {
                $0.delegate = firstFavoritesDelegate
                $0.favoriteSectionIndex = favoriteSectionIndex
                $0.hidesBottomBarWhenPushed = true
            }
        
        view?.viewController.navigationController?.pushViewController(firstFavoriritesView, animated: true)
    }
    
    func pushSystemSettings() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        
        UIApplication.shared.open(settingsUrl!, options: [:], completionHandler: nil)
    }
    
    func showOnboarding() {
        let onboarding = OnboardingRouter.createModule()
        
        UIApplication.load(vc: onboarding)
    }
    
}
