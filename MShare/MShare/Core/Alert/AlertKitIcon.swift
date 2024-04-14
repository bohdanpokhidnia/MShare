//
//  AlertKitIcon.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2023.
//

import UIKit

enum AlertKitIcon {
    case done
    case error
    case heart
    case custom(_ image: UIImage)
    
    func createView(lineThick: CGFloat) -> UIView {
        switch self {
        case .done: AlertKitIconDoneView(lineThick: lineThick)
        case .error: UIView()
        case .heart: UIView()
        case .custom(let image): customImageView(from: image)
        }
    }
}

// MARK: - Private Methods

private extension AlertKitIcon {
    func customImageView(from image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
