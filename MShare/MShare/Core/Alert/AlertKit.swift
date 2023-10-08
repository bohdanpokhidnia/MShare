//
//  AlertKit.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.10.2023.
//

import UIKit

enum AlertKit {
    static func present(title: String, haptic: AlertKitHaptic? = nil) {
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else { return }
        
        let alertKitView = AlertKitView(title: title, haptic: haptic)
        alertKitView.present(on: window)
    }
}
