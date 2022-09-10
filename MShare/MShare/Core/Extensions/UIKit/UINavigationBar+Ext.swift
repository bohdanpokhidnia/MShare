//
//  UINavigationBar+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 25.08.2022.
//

import UIKit

extension UINavigationBar {
    
    enum NavigationBarStyle {
        case defaultBackground, transcelent
    }
    
    static func configure(style: NavigationBarStyle) {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        switch style {
        case .defaultBackground:
            navigationBarAppearance.configureWithDefaultBackground()
            
        case .transcelent:
            navigationBarAppearance.configureWithTransparentBackground()
        }
        
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
}
