//
//  SettingsInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol SettingsInteractorIntputProtocol {
    var presenter: SettingsInteractorOutputProtocol? { get set }
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    
}

final class SettingsInteractor {
    weak var presenter: SettingsInteractorOutputProtocol?
}

// MARK: - SettingsInteractorInputProtocol

extension SettingsInteractor: SettingsInteractorIntputProtocol {
    
}
