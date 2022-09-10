//
//  UIImageView+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.08.2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    @discardableResult
    func setImage(_ aImage: UIImage?) -> Self {
        image = aImage
        return self
    }
    
    @discardableResult
    func setImage(_ urlString: String, placeholder: UIImage? = nil) -> Self {
        guard let imageURL = URL(string: urlString) else {
            image = placeholder
            return self
        }
        
        kf.setImage(with: imageURL, placeholder: placeholder) { [weak self] (result) in
            switch result {
            case .success(let imageResult):
                self?.image = imageResult.image
                
            case .failure(let error):
                self?.image = placeholder
                
                print("[dev] error fetch image on url: \(urlString) \(error)")
            }
        }
        return self
    }
    
    @discardableResult
    func setContentMode(_ contentMode: ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
}
