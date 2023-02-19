//
//  AppTheme.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.02.2023.
//

import UIKit

struct AppTheme {
    let components: UIComponentsLibrary
}

extension AppTheme {
    
    static let light = AppTheme(components: .init(
        favorites: .init(
            segmentControl: .init(
                active: .init(color: .white, font: .systemFont(ofSize: 18, weight: .semibold)),
                normal: .init(color: .secondaryLabel, font: .systemFont(ofSize: 18, weight: .semibold)),
                background: .init(color: .tertiarySystemBackground)
            ),
            background: .init(color: .secondarySystemBackground)
        ),
        link: .init(
            background: .init(color: .secondarySystemBackground)
        ),
        settings: .init(
            settingsCell: .init(background: .init(color: .systemBackground)),
            background: .init(color: .secondarySystemBackground)
        ),
        mediaCell: .init(
            icon: .init(color: .clear, cornerRadius: 5),
            position: .init(color: .label, font: .systemFont(ofSize: 18, weight: .bold)),
            title: .init(color: .label, font: .systemFont(ofSize: 17)),
            subtitle: .init(color: .secondaryLabel, font: .systemFont(ofSize: 17)),
            background: .init(color: .systemBackground)
        )
    ))
    
}

extension AppTheme {
    
    static let dark = AppTheme(components: .init(
        favorites: .init(
            segmentControl: .init(
                active: .init(color: .white, font: .systemFont(ofSize: 14)),
                normal: .init(color: .secondaryLabel, font: .systemFont(ofSize: 14)),
                background: .init(color: .tertiarySystemBackground)
            ),
            background: .init(color: .systemBackground)
        ),
        link: .init(
            background: .init(color: .systemBackground)
        ),
        settings: .init(
            settingsCell: .init(
                background: .init(color: .secondarySystemBackground)
            ),
            background: .init(color: .systemBackground)
        ),
        mediaCell: .init(
            icon: .init(color: .clear, cornerRadius: 5),
            position: .init(color: .label, font: .systemFont(ofSize: 18, weight: .bold)),
            title: .init(color: .label, font: .systemFont(ofSize: 17)),
            subtitle: .init(color: .secondaryLabel, font: .systemFont(ofSize: 17)),
            background: .init(color: .secondarySystemBackground)
        )
    ))
    
}
