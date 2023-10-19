//
//  AlertConfiguration.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 12.10.2023.
//

import UIKit

struct AlertConfiguration {
    let position: AlertPosition
    let height: CGFloat
    var insets: UIEdgeInsets?
    var haptic: AlertKitHaptic?
    var duration: TimeInterval?
}
