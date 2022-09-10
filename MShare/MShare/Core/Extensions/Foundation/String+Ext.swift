//
//  String+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 10.09.2022.
//

import Foundation

extension String {
    
    var isValidURL: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let symbolsCount = utf16.count
            guard let match = detector.firstMatch(in: self, range: NSRange(location: 0, length: symbolsCount)) else { return false }
            
            return match.range.length == symbolsCount
        } catch {
            return false
        }
    }
    
}
