//
//  DetailSongContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import SnapKit

typealias DetailSongState = DetailSongContentView.State

final class DetailSongContentView: View {
    
    struct State {
        let coverURL: String
        let artistName: String
        let songName: String
    }
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView()
        .setContentMode(.center)
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
            defineLayoutForCoverView($0, forPhone: UIScreen.phone)
            
            $0.centerX.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        horizontalActionMenuView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(HorizontalActionMenuView.HorizontalActionMenuHeight)
        }
    }
    
}

// MARK: - Set

extension DetailSongContentView {
    
    @discardableResult
    func set(state: State) -> Self {
        backgroundImageView.setImage(state.coverURL)
        coverView.set(state: state)
        
        return self
    }
    
}

// MARK: - Private Methods

private extension DetailSongContentView {
    
    func defineLayoutForCoverView(_ constraint: ConstraintMaker, forPhone phone: UIScreen.Phone) {
        switch phone {
        case .iPhoneSE1:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
            
        case .iPhone6_7_8_SE2_SE3:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
            
        case .iPhone6_7_8Plus:
            constraint.centerY.equalToSuperview().offset(-80)
            
        case .iPhoneXr_XsMax_11_12, .iPhoneX_11Pro_12Mini_13Mini, .iPhone12Pro_13_13Pro, .iPhone12_13ProMax:
            constraint.centerY.equalToSuperview().offset(-60)
            
        case .unknown:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
        }
    }
    
}
