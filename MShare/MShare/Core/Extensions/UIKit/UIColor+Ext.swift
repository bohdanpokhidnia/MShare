//
//  UIColor+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.08.2022.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        guard hex.hasPrefix("#") else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
            return
        }

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                let b = CGFloat(hexNumber & 0x0000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: alpha)
                return
            }
        }

        self.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
}

extension UIColor {
    static let appPink = UIColor(hex: "#d12d9c")
    static let appBlue = UIColor(hex: "#5ea2ef")
    static let appGray = UIColor(hex: "#D0D1D3")
}

extension Array where Element == UIColor {
    static let appGradientColors: [UIColor] = [.appPink, .appPink, .appBlue, .appBlue]
}
