//
//  UIStyleGuide.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.01.2023.
//

import UIKit

enum UIStyleGuide {
    
    enum Typography {
        static func gilroy(weight: UIFont.Weight, size: CGFloat) -> UIFont {
            let sWeight = stringFrom(weight: weight)
            guard let font = UIFont(name: "Gilroy-" + sWeight, size: size) else {
                assertionFailure("missing required font")
                return UIFont.systemFont(ofSize: size)
            }
            return font
        }
        
        private static func stringFrom(weight: UIFont.Weight) -> String {
            switch weight {

            case .semibold:
                return "Semibold"

            case .bold:
                return "Bold"

            default:
                assertionFailure("missing required weight")
                return stringFrom(weight: .semibold)
            }
        }
    }

}

extension UIFont {
    
    ///gilroy, .bold, size: 42
    static let appName = UIStyleGuide.Typography.gilroy(weight: .bold, size: 42)
    
    ///gilroy, .semibold, size: 16
    static let onboardingDescription = UIStyleGuide.Typography.gilroy(weight: .semibold, size: 16)
    
    ///gilroy, .semibold, size: 18
    static let onboardingAction = UIStyleGuide.Typography.gilroy(weight: .semibold, size: 18)
    
}
