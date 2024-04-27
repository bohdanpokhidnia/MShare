//
//  SettingsInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol SettingsInteractorIntputProtocol {
    var presenter: SettingsInteractorOutputProtocol? { get set }
    
    func makeSettingsSections()
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
    func makeSettingsSections() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        guard let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return
        }
        let versionAppString: String
        
        #if DEBUG
        versionAppString = "\(appVersion) (\(buildVersion))"
        #else
        versionAppString = "\(appVersion)"
        #endif
        
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
        userManager.reset()
        
        presenter?.didShowOnboarding()
    }
}

// MARK: - Make sections

private extension SettingsInteractor {
    func makeSettingsSection(versionAppString: String) -> [SettingsSection] {
        let settingsSections: [SettingsSection] = [
            SettingsSection(
                title: "Favorites",
                items: [.firstFavorites]
            ),
            SettingsSection(
                title: "Access",
                items: [.accessToGallery]
            ),
            SettingsSection(
                title: "Information",
                items: [
                    .aboutUs,
                    .privacyPolicyAndTerms,
                    .support,
                    .versionApp(versionAppString)
                ]
            )
        ]
        
        return settingsSections
    }
}
