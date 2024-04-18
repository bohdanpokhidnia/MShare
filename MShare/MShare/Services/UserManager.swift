//
//  UserManager.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.11.2022.
//

import Foundation

protocol UserManagerProtocol {
    var favoriteFirstSection: Int? { get set }
    var isDisplayOnboarding: Bool? { get set }
    var isDisplaySearchTip: Bool? { get set }
    
    func reset()
}

final class UserManager: UserManagerProtocol {
    @UserDefault("favoriteFirstSection", defaultValue: 0) var favoriteFirstSection: Int?
    @UserDefault("isDisplayOnboarding", defaultValue: false) var isDisplayOnboarding: Bool?
    @UserDefault("isDisplaySearchTip", defaultValue: false) var isDisplaySearchTip: Bool?
    
    func reset() {
        favoriteFirstSection = nil
        isDisplayOnboarding = nil
        isDisplaySearchTip = nil
    }
}
