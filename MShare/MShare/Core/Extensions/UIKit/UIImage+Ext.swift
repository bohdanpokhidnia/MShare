//
//  UIImage+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.03.2023.
//

import UIKit

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        let size = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return newImage
    }
    
    func applyGradient(for systemIcons: Bool = true, colors: [UIColor], start: GradientDirection, end: GradientDirection) -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray
        
        if systemIcons {
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
        }
        context.clip(to: CGRect(origin: .zero, size: self.size), mask: cgImage)
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.drawLinearGradient(
            gradient,
            start: start.point(for: size, flipped: systemIcons),
            end: end.point(for: size, flipped: systemIcons),
            options: []
        )
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
