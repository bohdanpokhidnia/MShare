//
//  AlertKit.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.10.2023.
//

import UIKit

enum AlertKit {
    private static var currentWindow: UIWindow? {
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        return window
    }
    
    static func shortToast(
        title: String,
        icon: AlertKitIcon,
        position: AlertPosition,
        haptic: AlertKitHaptic? = nil,
        inset: CGFloat? = nil
    ) {
        guard let currentWindow else { 
            return
        }
        let shortView = AlertKitShortView(
            title: title,
            icon: icon,
            mainView: currentWindow,
            configuration: AlertConfiguration(
                position: position,
                height: 50.0,
                inset: inset,
                haptic: haptic,
                displayDuration: 1.0
            )
        )
        
        shortView.present()
    }
}
