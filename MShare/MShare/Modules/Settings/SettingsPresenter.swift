//
//  SettingsPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SettingsPresenterProtocol: AnyObject {
    var view: SettingsViewProtocol? { get set }
    var interactor: SettingsInteractorIntputProtocol? { get set }
    var router: SettingsRouterProtocol? { get set }
    
    func viewDidLoad()
    func settingsSectionCount() -> Int
    func settingsSectionTitle(atSection section: Int) -> String
    func settingsItemsCount(atSection section: Int) -> Int
    func settingsItemStateInSection(atSection section: Int, andIndex index: Int) -> SettingsEntity
    func didTapSettingItem(atSection section: Int, andIndex index: Int)
    func didSelectFavoriteSection(_ sectionIndex: Int)
}

final class SettingsPresenter {
    weak var view: SettingsViewProtocol?
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
    
    func settingsItemStateInSection(atSection section: Int, andIndex index: Int) -> SettingsEntity {
        let settingsSection = settingsSections[section]
        let settingsItem = settingsSection.items[index]
        return makeSettingsEntity(settingsItem: settingsItem)
    }
    
    func didTapSettingItem(atSection section: Int, andIndex index: Int) {
        let settingsSection = settingsSections[section]
        let settingsItem = settingsSection.items[index]
        
        switch settingsItem {
        case .firstFavorites:
            interactor?.loadFavoritesSectionIndex()
            
        case .accessToGallery:
            router?.pushSystemSettings()
            
        case .aboutUs:
            router?.pushAboutUsScreen(from: view)
            
        case .privacyPolicyAndTerms:
            router?.presentBrowserScreen(from: view, forUrlString: "https://www.google.com.ua")
            
        case .versionApp:
            interactor?.showOnboarding()
        }
    }
    
    func didSelectFavoriteSection(_ sectionIndex: Int) {
        interactor?.saveFavoritesSectionIndex(sectionIndex)
    }
    
}

// MARK: - SettingsInteractorOutputProtocol

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
    func didCatchSettingsSections(_ settingsSection: [SettingsSection]) {
        self.settingsSections.removeAll()
        self.settingsSections = settingsSection
    }
    
    func didLoadFavoriteSectionIndex(_ sectionIndex: Int) {
        router?.pushFirstFavoritesScreen(fromView: view, favoriteSectionIndex: sectionIndex, firstFavoritesDelegate: view!)
    }
    
    func didShowOnboarding() {
        router?.showOnboarding()
    }
    
}

// MARK: - Make settings entity

private extension SettingsPresenter {
    
    func makeSettingsEntity(settingsItem: SettingsItem) -> SettingsEntity {
        switch settingsItem {
        case .firstFavorites:
            return .init(
                title: "First Favorites",
                image: UIImage(named: "hearth"),
                accesoryType: .disclosureIndicator
            )
            
        case .accessToGallery:
            return .init(
                title: "Access to gallery",
                image:  UIImage(systemName: "photo.on.rectangle.angled"),
                accesoryType: .disclosureIndicator
            )
            
        case .aboutUs:
            return .init(title: "About Us",
                         image: UIImage(named: "group"),
                         accesoryType: .disclosureIndicator)
            
        case .privacyPolicyAndTerms:
            return .init(
                title: "Privacy Policy & Terms",
                image: UIImage(named: "privacyPolicy"),
                accesoryType: .disclosureIndicator
            )
            
        case .versionApp(let versionAppString):
            return .init(
                title: "Version: \(versionAppString)",
                image: UIImage(named: "AppIcon"),
                accesoryType: UITableViewCell.AccessoryType.none
            )
        }
    }
    
}
