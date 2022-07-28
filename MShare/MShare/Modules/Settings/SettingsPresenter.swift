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
}

final class SettingsPresenter {
    var view: SettingsViewProtocol?
    var interactor: SettingsInteractorIntputProtocol?
    var router: SettingsRouterProtocol?
}

// MARK: - SettingsPresenterProtocol

extension SettingsPresenter: SettingsPresenterProtocol {
    
}

// MARK: - SettingsInteractorOutputProtocol

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
}
