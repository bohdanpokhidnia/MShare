//
//  AlertKitHaptic.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.10.2023.
//

import UIKit

enum AlertKitHaptic {
    case success
    case warning
    case error
    case none
    
    func notify() {
        let generator = UINotificationFeedbackGenerator()
        
        switch self {
        case .success:
            generator.notificationOccurred(.success)
            
        case .warning:
            generator.notificationOccurred(.warning)
            
        case .error:
            generator.notificationOccurred(.error)
            
        case .none:
            break
        }
    }
}
