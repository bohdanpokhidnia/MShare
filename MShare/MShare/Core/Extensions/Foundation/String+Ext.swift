//
//  String+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 10.09.2022.
//

import UIKit

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
    
    func toImage(size: CGSize) -> UIImage? {
        let nsString = (self as NSString)
        let fontSize = (size.width + size.height) / 2
        let stringAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
