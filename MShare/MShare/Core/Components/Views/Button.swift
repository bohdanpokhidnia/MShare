//
//  Button.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.08.2022.
//

import UIKit

class Button: UIButton, ViewLayoutableProtocol {
    // MARK: - Override property
    
    override var bounds: CGRect {
        didSet { gradientLayer.frame = bounds }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupSubviews()
        defineLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLayoutableProtocol
    
    func setup() {
        
    }
    
    func setupSubviews() {
        
    }
    
    func defineLayout() {
        
    }
    
    // MARK: - Private
    
    private var didTapAction: (() -> Void) = { }
    private var colors = [CGColor]()
    
    private lazy var gradientLayer = CAGradientLayer()
        .make {
            $0.colors = colors
            $0.zPosition = -1000
            
            layer.insertSublayer($0, at: 0)
        }
}

// MARK: - User interactions

private extension Button {
    @objc
    func tapButton(_ button: UIButton) {
        didTapAction()
    }
}

// MARK: - Set

extension Button {
    @discardableResult
    func onTap(action: @escaping () -> Void) -> Self {
        didTapAction = action
        addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        return self
    }
    
    @discardableResult
    func setImage(_ image: UIImage?, forState state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func setTitle(_ title: String, forState state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        
        return self
    }
    
    @discardableResult
    func setTitleColor(_ color: UIColor, forState state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        
        if state == .normal {
            setTitleColor(color.withAlphaComponent(0.7), for: .highlighted)
        }
        return self
    }
    
    @discardableResult
    func set(font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func set(colors: [UIColor]) -> Self {
        self.colors = colors.map { $0.cgColor }
        return self
    }
    
    @discardableResult
    func set(startPoint: GradientDirection, endPoint: GradientDirection) -> Self {
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        return self
    }
}
