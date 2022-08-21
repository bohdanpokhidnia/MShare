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
            $0.centerY.equalToSuperview().offset(-coverView.frame.height / 7)
            $0.centerX.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        horizontalActionMenuView.snp.makeConstraints {
            $0.top.equalTo(coverViewContainer.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(HorizontalActionMenuView.HorizontalActionMenuWidth)
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
