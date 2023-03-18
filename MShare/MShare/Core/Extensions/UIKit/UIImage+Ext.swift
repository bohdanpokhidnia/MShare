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
    
}
