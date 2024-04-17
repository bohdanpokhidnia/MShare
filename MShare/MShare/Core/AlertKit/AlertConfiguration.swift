//
//  AlertConfiguration.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 12.10.2023.
//

import UIKit

struct AlertConfiguration {
    let position: AlertPosition
    var isUseSafeArea: Bool = true
    let height: CGFloat
    var inset: CGFloat?
    var haptic: AlertKitHaptic?
    var presentationDuration: CGFloat = 0.5
    var displayDuration: CGFloat?
    var dismissDuration: CGFloat = 0.5
}
