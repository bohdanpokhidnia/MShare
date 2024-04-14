//
//  MakeCoverContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import UIKit
import SnapKit

final class MakeCoverContentView: ViewLayoutable {
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .addClearBackgroundBlur(style: .regular)
    
    private let coverViewContainer = ViewLayoutable()
        .maskToBounds(false)
        .setCornerRadius(28)
        .addShadow(color: .black, offset: .init(width: 4, height: 4), opacity: 0.3, radius: 10)
    
    private(set) var coverView = CoverView()
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .white)
        maskToBounds(true)
        coverViewContainer.addGestureRecognizer(panGesture)
        coverViewContainer.addGestureRecognizer(pinchGesture)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        coverViewContainer.addSubview(coverView)
        addSubviews(
            backgroundImageView,
            coverViewContainer
        )
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverViewContainer.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private
    
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanTray))
    private lazy var pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
    
}

//MARK: - Set

extension MakeCoverContentView {
    
    @discardableResult
    func set(state: DetailSongEntity) -> Self {
        backgroundImageView.setImage(state.image)
        coverView.set(state: state)
        return self
    }
    
}

// MARK: - User interactions

private extension MakeCoverContentView {
    
    @objc
    func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        coverViewContainer.center.x += translation.x
        coverViewContainer.center.y += translation.y
        sender.setTranslation(.zero, in: self)
    }
    
    @objc
    func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        coverViewContainer.transform = coverViewContainer.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
    
}
