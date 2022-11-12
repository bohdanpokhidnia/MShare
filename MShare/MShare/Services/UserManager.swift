//
//  UserManager.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.11.2022.
//

import Foundation

protocol UserManagerProtocol {
    var favoriteFirstSection: Int? { get set }
}

final class UserManager: UserManagerProtocol {
    
    @UserDefault("favoriteFirstSection", defaultValue: 0) var favoriteFirstSection: Int?
    
}
