//
//  SettingsPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    var view: SettingsViewProtocol? { get set }
    var interactor: SettingsInteractorIntputProtocol? { get set }
    var router: SettingsRouterProtocol? { get set }
    
    func viewDidLoad()
    func settingsSectionCount() -> Int
    func settingsSectionTitle(atSection section: Int) -> String
    func settingsItemsCount(atSection section: Int) -> Int
    func settingsItemStateInSection(atSection section: Int, andIndex index: Int) -> SettingsItemState
    func didTapSettingItem(atSection section: Int, andIndex index: Int)
}

final class SettingsPresenter {
    var view: SettingsViewProtocol?
    var interactor: SettingsInteractorIntputProtocol?
    var router: SettingsRouterProtocol?
    
    private var settingsSections = [SettingsSection]()
}

// MARK: - SettingsPresenterProtocol

extension SettingsPresenter: SettingsPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.makeSettinsSections()
    }
    
    func settingsSectionCount() -> Int {
        return settingsSections.count
    }
    
    func settingsSectionTitle(atSection section: Int) -> String {
        let settingsSection = settingsSections[section]
        return settingsSection.title
    }
    
    func settingsItemsCount(atSection section: Int) -> Int {
        let settingsSection = settingsSections[section]
        let countItems = settingsSection.items.count
        
        return countItems
    }
    
    func settingsItemStateInSection(atSection section: Int, andIndex index: Int) -> SettingsItemState {
        let settingsSection = settingsSections[section]
        let settingsItem = settingsSection.items[index]
        let settingsItemState = SettingsItemState(title: settingsItem.title,
                                                  image: settingsItem.image,
                                                  accesoryType: settingsItem.accessoryType)
        
        return settingsItemState
    }
    
    func didTapSettingItem(atSection section: Int, andIndex index: Int) {
        let settingsSection = settingsSections[section]
        let settingsItem = settingsSection.items[index]
        
        switch settingsItem {
        case .firstFavorites:
            break
            
        case .aboutUs:
            guard let view else { return }
            router?.pushAboutUsScreen(from: view)
            
        case .privacyPolicyAndTerms:
            guard let view else { return }
            router?.presentBrowserScreen(from: view, forUrlString: "https://www.google.com.ua")
        }
    }
    
}

// MARK: - SettingsInteractorOutputProtocol

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
    func didCatchSettingsSections(_ settingsSection: [SettingsSection]) {
        self.settingsSections.removeAll()
        self.settingsSections = settingsSection
    }
    
}
