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
    
    static func toast(title: String, position: AlertPosition, haptic: AlertKitHaptic? = nil) {
        guard let currentWindow else { return }
        
        let horizontalInset: CGFloat = 16.0
        let bottomInset: CGFloat = 26.0
        
        let toastView = AlertKitToastView(
            title: title,
            view: currentWindow,
            configutation: AlertConfiguration(
                position: position,
                height: 49.0,
                insets: UIEdgeInsets(top: 0, left: horizontalInset, bottom: bottomInset, right: horizontalInset),
                haptic: haptic
            )
        )
        
        toastView.presentAlert()
    }
    
    static func shortToast(
        title: String,
        icon: AlertKitIcon,
        position: AlertPosition,
        haptic: AlertKitHaptic? = nil
    ) {
        guard let currentWindow else { return }
        
        let shortView = AlertKitShortView(
            title: title,
            icon: icon,
            view: currentWindow,
            configuration: AlertConfiguration(
                position: position,
                height: 50.0,
                haptic: haptic,
                duration: 1.0
            )
        )
        
        shortView.presentAlert()
    }
}
