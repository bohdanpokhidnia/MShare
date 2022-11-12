//
//  View.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit
import SnapKit

let kDefaultViewSize = CGSize(width: 320, height: 528)

enum ViewState {
    case initial,
         loading,
         ready,
         error,
         empty
}

class View: UIView, ViewLayoutableProtocol {

    var shadowLayers = Set<CAShapeLayer>()

    required init() {
        super.init(frame: .init(origin: .zero, size: kDefaultViewSize))

        setup()
        setupSubviews()
        defineLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
        setupSubviews()
        defineLayout()
    }

    func setup() {
        
    }

    func setupSubviews() {

    }

    func defineLayout() {

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        shadowLayers.forEach {
            $0.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
            $0.shadowPath = $0.path
        }
    }

}

// MARK: - Shadows

extension View {

    @discardableResult
    func addShadow(color: UIColor,
                   offset: CGSize,
                   opacity: Float,
                   radius: CGFloat,
                   fillColor: UIColor = .clear) -> Self {
        let shadowLayer = CAShapeLayer()

        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor

        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius

        layer.insertSublayer(shadowLayer, at: 0)
        shadowLayers.insert(shadowLayer)

        return self
    }

    @discardableResult
    func removeShadows() -> Self {
        shadowLayers.forEach { $0.removeFromSuperlayer() }
        shadowLayers = []
        return self
    }

}

extension UIView {
    
    @discardableResult
    func cornersRadiusOnly(_ radius: CGFloat,
                           topLeft: Bool = false,
                           topRight: Bool = false,
                           bottomLeft: Bool = false,
                           bottomRight: Bool = false) -> Self {
        
        var corners = CACornerMask()
        
        if topLeft {
            corners.insert(.layerMinXMinYCorner)
        }
        if topRight {
            corners.insert(.layerMaxXMinYCorner)
        }
        if bottomLeft {
            corners.insert(.layerMinXMaxYCorner)
        }
        if bottomRight {
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        
        return self
    }

    @discardableResult
    func setCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        return self
    }

    @discardableResult
    func backgroundColor(color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    func maskToBounds(_ enabled: Bool) -> Self {
        layer.masksToBounds = enabled
        return self
    }

    @discardableResult
    func hidden(_ aIsHidden: Bool) -> Self {
        isHidden = aIsHidden
        return self
    }

    @discardableResult
    func tint(color: UIColor) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    func setAlpha(_ aAlpha: CGFloat) -> Self {
        alpha = aAlpha
        return self
    }

    @discardableResult
    func borderWidth(_ value: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = value
        layer.borderColor = color.cgColor
        return self
    }

    @discardableResult
    func borderWidth(_ value: CGFloat) -> Self {
        layer.borderWidth = value
        return self
    }

    @discardableResult
    func apply(transform newTransform: CGAffineTransform) -> Self {
        transform = newTransform
        return self
    }

    func makeSnapShotImage(withBackground background: Bool) -> UIImage? {
        var snapShotImage: UIImage?
        
        if background {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            snapShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.saveGState()
            layer.render(in: context)
            context.restoreGState()
            snapShotImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        return snapShotImage
    }

}

extension UIView {

    @discardableResult
    func addSubviews(_ subviews: UIView...) -> Self {
        subviews.forEach { addSubview($0) }
        return self
    }
    
    func convertSelfBounds(to space: UICoordinateSpace) -> CGRect {
        return convert(bounds, to: space)
    }

}
