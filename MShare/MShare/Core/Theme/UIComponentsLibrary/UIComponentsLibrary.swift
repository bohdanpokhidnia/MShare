//
//  UIComponentsLibrary.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.02.2023.
//

import UIKit

struct UIComponentsLibrary {
    
    struct Component {
        var color: UIColor
        var opacity: CGFloat = 1.0
        var cornerRadius: CGFloat = 0.0
    }
    
    struct TextComponent {
        var color: UIColor
        var font: UIFont
    }
    
    struct Button {
        var text: TextComponent
        var background: Component
    }
    
    let favorites: Favorites
    let link: Link
    let settings: Settings
    let mediaCell: MediaCell
    
}
