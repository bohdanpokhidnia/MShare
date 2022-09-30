//
//  DetailSongContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import SnapKit

final class DetailSongContentView: View {
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .addClearBackgroundBlur(style: .regular)
    
    private let coverViewContainer = View()
        .maskToBounds(false)
        .setCornerRadius(28)
        .addShadow(color: .black, offset: .init(width: 4, height: 4), opacity: 0.3, radius: 10)
    
    private let coverView = CoverView()
    
    private(set) var horizontalActionMenuView = HorizontalActionMenuView()
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        coverViewContainer.addSubview(coverView)
        addSubviews(backgroundImageView, coverViewContainer, horizontalActionMenuView)
    }
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .white)
        maskToBounds(true)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverViewContainer.snp.makeConstraints {
            defineLayoutForCoverView($0, forPhone: UIDevice.phone)
            
            $0.centerX.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        horizontalActionMenuView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(HorizontalActionMenuView.HorizontalActionMenuHeight + 50)
        }
    }
    
}

// MARK: - Set

extension DetailSongContentView {
    
    @discardableResult
    func set(state: DetailSongEntity) -> Self {
        backgroundImageView.setImage(state.image)
        coverView.set(state: state)
        
        return self
    }
    
    func makeImage() -> UIImage? {
        horizontalActionMenuView.isHidden = true
        
        let oldCenter = coverViewContainer.center
        coverViewContainer.center = center
        
        defer {
            horizontalActionMenuView.isHidden = false
            coverViewContainer.center = oldCenter
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: - Private Methods

private extension DetailSongContentView {
    
    func defineLayoutForCoverView(_ constraint: ConstraintMaker, forPhone phone: UIDevice.Phone) {
        switch phone {
        case .iPhoneSE:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
            
//        case .iPhone6_7_8_SE2_SE3
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(20)
            
//        case .iPhone6_7_8Plus:
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            constraint.centerY.equalToSuperview().offset(-80)
            
//        case .iPhoneXr_XsMax_11_12, .iPhone12Pro_13_13Pro_14, .iPhoneX_11Pro_12Mini_13Mini, .iPhone12_13ProMax_14Plus, .iPhone14Pro, .iPhone14ProMax:
        case .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11ProMax, .iPhone12, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Pro, .iPhone14, .iPhoneX, .iPhone11Pro, .iPhone12Mini, .iPhone13Mini, .iPhone13ProMax, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax:
            constraint.centerY.equalToSuperview().offset(-130)
            
        case .simulator, .unrecognized:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
        }
    }
    
}
