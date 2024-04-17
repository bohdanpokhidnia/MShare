//
//  GradientLabel.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2024.
//

import UIKit

final class GradientLabel: UILabel {
    let colors: [UIColor]
    let start: GradientDirection
    let end: GradientDirection
    
    init(colors: [UIColor], start: GradientDirection, end: GradientDirection) {
        self.colors = colors
        self.start = start
        self.end = end
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Override methods

    override func drawText(in rect: CGRect) {
        if let gradientColor = makeGradientColor(in: rect, colors: colors.map { $0.cgColor }) {
            self.textColor = gradientColor
        }
        
        super.drawText(in: rect)
    }
}

// MARK: - Private Methods

private extension GradientLabel {
    func makeGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        let size = rect.size
        currentContext?.saveGState()
        
        defer {
            currentContext?.restoreGState()
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
        ) else {
            return nil
        }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(
            gradient,
            start: start.point(for: .zero),
            end: end.point(for: size),
            options: []
        )
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else {
            return nil
        }
        let color = UIColor(patternImage: image)
        return color
    }
}
