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
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    func didCatchSettingsSections(_ settingsSection: [SettingsSection])
}

final class SettingsInteractor {
    weak var presenter: SettingsInteractorOutputProtocol?
}

// MARK: - SettingsInteractorInputProtocol

extension SettingsInteractor: SettingsInteractorIntputProtocol {
    
    func makeSettinsSections() {
        let settingsSections: [SettingsSection] = [.favorites([.firstFavorites]),
                                                           .privacy([.aboutUs, .privacyPolicyAndTerms])]
        
        presenter?.didCatchSettingsSections(settingsSections)
    }
    
}
