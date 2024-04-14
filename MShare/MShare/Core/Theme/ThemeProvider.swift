//
//  ThemeProvider.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.02.2023.
//

import Foundation

final class ThemeProvider {
    static let shared = ThemeProvider()
    
    private(set) var theme: AppTheme = .light
    
    private let observers = NSHashTable<AnyObject>.weakObjects()
}

//MARK: - AppThemeProvider

extension ThemeProvider: AppThemeProvider {
    func set(theme: AppTheme) {
        self.theme = theme
        
        observers.allObjects
            .compactMap { $0 as? Themeable }
            .forEach { $0.apply(theme: theme) }
    }
    
    func register<Observer: Themeable>(observer: Observer) {
        observers.add(observer)
        observer.apply(theme: theme)
    }
    
    func unregister<Observer: Themeable>(observer: Observer) {
        observers.remove(observer)
    }
}
