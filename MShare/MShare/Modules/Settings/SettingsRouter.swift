//
//  SettingsRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SafariServices

protocol SettingsRouterProtocol {
    func pushAboutUsScreen(from view: SettingsViewProtocol?)
    func presentBrowserScreen(from view: SettingsViewProtocol?, forUrlString urlString: String)
    func pushFirstFavoritesScreen(fromView view: SettingsViewProtocol?, favoriteSectionIndex: Int, firstFavoritesDelegate: FirstFavoritesDelegate)
    func pushSystemSettings()
    func loadOnboarding()
}

final class SettingsRouter: Router {
    override func createModule() -> UIViewController {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        
        let view: SettingsViewProtocol = SettingsView()
        let presenter: SettingsPresenterProtocol & SettingsInteractorOutputProtocol = SettingsPresenter(view: view, router: self)
        let interactor: SettingsInteractorIntputProtocol = SettingsInteractor(
            presenter: presenter,
            userManager: userManager
        )
        
        view.presenter = presenter
        presenter.interactor = interactor
        
        let navigationController = AppNavigationController(rootViewController: view.viewController)
        return navigationController
    }
}

//MARK: - SettingsRouterProtocol

extension SettingsRouter: SettingsRouterProtocol {
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
    
    func loadOnboarding() {
        appRouter?.loadOnboarding()
    }
}
