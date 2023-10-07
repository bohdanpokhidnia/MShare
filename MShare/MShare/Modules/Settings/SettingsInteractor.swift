//
//  SettingsInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol SettingsInteractorIntputProtocol {
    var presenter: SettingsInteractorOutputProtocol? { get set }
    
    func makeSettinsSections()
    func loadFavoritesSectionIndex()
    func saveFavoritesSectionIndex(_ sectionIndex: Int)
    func showOnboarding()
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    func didCatchSettingsSections(_ settingsSection: [SettingsSection])
    func didLoadFavoriteSectionIndex(_ sectionIndex: Int)
    
    func didShowOnboarding()
}

final class SettingsInteractor {
    weak var presenter: SettingsInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(
        presenter: SettingsInteractorOutputProtocol?,
        userManager: UserManagerProtocol
    ) {
        self.presenter = presenter
        self.userManager = userManager
    }
    
    // MARK: - Private
    
    private var userManager: UserManagerProtocol
}

// MARK: - SettingsInteractorInputProtocol

extension SettingsInteractor: SettingsInteractorIntputProtocol {
    
    func makeSettinsSections() {
        guard let versionAppString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        else { return }
        let settingsSections = makeSettingsSection(versionAppString: versionAppString)
        
        presenter?.didCatchSettingsSections(settingsSections)
    }
    
    func loadFavoritesSectionIndex() {
        let sectionIndex = userManager.favoriteFirstSection ?? 0
        
        presenter?.didLoadFavoriteSectionIndex(sectionIndex)
    }
    
    func saveFavoritesSectionIndex(_ sectionIndex: Int) {
        userManager.favoriteFirstSection = sectionIndex
    }
    
    func showOnboarding() {
        userManager.displayOnboarding = false
        
        presenter?.didShowOnboarding()
    }
    
}

// MARK: - Make sections

private extension SettingsInteractor {
    
    func makeSettingsSection(versionAppString: String) -> [SettingsSection] {
        let settingsSections: [SettingsSection] = [
            .init(
                title: "Favorites",
                items: [.firstFavorites]
            ),
            .init(
                title: "Access",
                items: [.accessToGallery]
            ),
            .init(
                title: "Information",
                items: [.aboutUs, .privacyPolicyAndTerms, .versionApp(versionAppString)]
            )
        ]
        
        return settingsSections
    }
    
}
