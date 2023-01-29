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
    private var userManager: UserManagerProtocol
    weak var presenter: SettingsInteractorOutputProtocol?
    
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
    
}

// MARK: - SettingsInteractorInputProtocol

extension SettingsInteractor: SettingsInteractorIntputProtocol {
    
    func makeSettinsSections() {
        guard let versionAppString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        else { return }
        
        let settingsSections: [SettingsSection] = [.favorites([.firstFavorites]),
                                                   .access([.accessToGallery]),
                                                   .privacy([.aboutUs,
                                                             .privacyPolicyAndTerms,
                                                             .versionApp(versionAppString)])]
        
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
