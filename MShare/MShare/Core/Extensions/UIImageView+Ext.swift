//
//  UIImageView+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.08.2022.
//

import UIKit

extension UIImageView {
    
    @discardableResult
    func setImage(_ aImage: UIImage?) -> Self {
        image = aImage
        return self
    }
    
}
