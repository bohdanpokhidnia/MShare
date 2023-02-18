//
//  Themeable.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.02.2023.
//

import UIKit

protocol Themeable: AnyObject {
    func apply(theme: AppTheme)
}

//MARK: - UITraitEnvironment

extension Themeable where Self: UITraitEnvironment {
    
    var themeProvider: ThemeProvider {
        return ThemeProvider.shared
    }
    
}
