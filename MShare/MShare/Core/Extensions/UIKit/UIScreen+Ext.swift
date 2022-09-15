//
//  UIScreen+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.09.2022.
//

import UIKit

extension UIScreen {
    
    enum Phone: CGFloat {
        case iPhoneSE1 = 568
        case iPhone6_7_8_SE2_SE3 = 667
        case iPhone6_7_8Plus = 736
        case iPhoneX_11Pro_12Mini_13Mini = 812
        case iPhoneXr_XsMax_11_12 = 896
        case iPhone12Pro_13_13Pro_14 = 844
        case iPhone12_13ProMax_14Plus = 926
        case iPhone14Pro = 852
        case iPhone14ProMax = 932
        case unknown
    }
    
    static let phone = Phone(rawValue: main.bounds.height) ?? .unknown
    
}
