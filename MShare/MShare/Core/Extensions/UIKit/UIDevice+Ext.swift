//
//  UIDevice+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.09.2022.
//

import UIKit

extension UIDevice {
    
    enum Phone: String {
        case simulator          = "arm64"
        case unrecognized       = "?unrecognized?"
        case iPhone6            = "iPhone 6"
        case iPhone6Plus        = "iPhone 6 Plus"
        case iPhone6S           = "iPhone 6S"
        case iPhone6SPlus       = "iPhone 6S Plus"
        case iPhoneSE           = "iPhone SE"
        case iPhone7            = "iPhone 7"
        case iPhone7Plus        = "iPhone 7 Plus"
        case iPhone8            = "iPhone 8"
        case iPhone8Plus        = "iPhone 8 Plus"
        case iPhoneX            = "iPhone X"
        case iPhoneXS           = "iPhone XS"
        case iPhoneXSMax        = "iPhone XS Max"
        case iPhoneXR           = "iPhone XR"
        case iPhone11           = "iPhone 11"
        case iPhone11Pro        = "iPhone 11 Pro"
        case iPhone11ProMax     = "iPhone 11 Pro Max"
        case iPhone12Mini       = "iPhone 12 mini"
        case iPhone12           = "iPhone 12"
        case iPhone12Pro        = "iPhone 12 Pro"
        case iPhone12ProMax     = "iPhone 12 Pro Max"
        case iPhone13Mini = "iPhone 13 mini"
        case iPhone13 = "iPhone 13"
        case iPhone13Pro = "iPhone 13 Pro"
        case iPhone13ProMax = "iPhone 13 Pro Max"
        case iPhone14 = "iPhone 14"
        case iPhone14Plus = "iPhone 14 Plus"
        case iPhone14Pro = "iPhone 14 Pro"
        case iPhone14ProMax = "iPhone 14 Pro Max"
    }
    
    static var phone: Phone {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        let modelMap: [String: Phone] = [
            "arm64"      : .simulator,
            "iPhone7,1"  : .iPhone6Plus,
            "iPhone7,2"  : .iPhone6,
            "iPhone8,1"  : .iPhone6S,
            "iPhone8,2"  : .iPhone6SPlus,
            "iPhone8,4"  : .iPhoneSE,
            "iPhone9,1"  : .iPhone7,
            "iPhone9,3"  : .iPhone7,
            "iPhone9,2"  : .iPhone7Plus,
            "iPhone9,4"  : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            "iPhone14,4" : .iPhone13Mini,
            "iPhone14,5" : .iPhone13,
            "iPhone14,2" : .iPhone13Pro,
            "iPhone14,3" : .iPhone13ProMax,
            "iPhone14,7" : .iPhone14,
            "iPhone14,8" : .iPhone14Plus,
            "iPhone15,2" : .iPhone14Pro,
            "iPhone15,3" : .iPhone14ProMax
        ]
        
        if let model = modelMap[String(modelCode!)] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String(simModelCode)] {
                        return simModel
                    }
                }
            }
            
            return model
        }
        
        return Phone.unrecognized
    }
    
}
