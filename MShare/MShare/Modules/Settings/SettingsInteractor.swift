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
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    func didCatchSettingsSections(_ settingsSection: [SettingsSection])
    func didLoadFavoriteSectionIndex(_ sectionIndex: Int)
}

final class SettingsInteractor {
    weak var presenter: SettingsInteractorOutputProtocol?
    
    private var userManager: UserManagerProtocol = UserManager()
}

// MARK: - SettingsInteractorInputProtocol

extension SettingsInteractor: SettingsInteractorIntputProtocol {
    
    func makeSettinsSections() {
        let settingsSections: [SettingsSection] = [.favorites([.firstFavorites]),
                                                   .privacy([.aboutUs, .privacyPolicyAndTerms])]
        
        presenter?.didCatchSettingsSections(settingsSections)
    }
    
    func loadFavoritesSectionIndex() {
        let sectionIndex = userManager.favoriteFirstSection ?? 0
        
        presenter?.didLoadFavoriteSectionIndex(sectionIndex)
    }
    
    func saveFavoritesSectionIndex(_ sectionIndex: Int) {
        userManager.favoriteFirstSection = sectionIndex
    }
    
}
