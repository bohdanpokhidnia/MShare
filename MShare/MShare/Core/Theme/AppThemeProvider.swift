//
//  AppThemeProvider.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.02.2023.
//

import Foundation

protocol AppThemeProvider {
    var theme: AppTheme { get }
    
    func set(theme: AppTheme)
    
    func register<Observer: Themeable>(observer: Observer)
    func unregister<Observer: Themeable>(observer: Observer)
}
