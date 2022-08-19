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
    
    static let horizontalActionMenuHeight: CGFloat = 135
    
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
    
    private let horizontalActionMenuContainer = View()
        .setAlpha(0)
    
    private(set) var horizontalActionMenuView = HorizontalActionMenuView()
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        coverViewContainer.addSubview(coverView)
        horizontalActionMenuContainer.addSubview(horizontalActionMenuView)
        addSubviews(backgroundImageView, coverViewContainer, horizontalActionMenuContainer)
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
            $0.top.equalTo(safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        horizontalActionMenuContainer.snp.makeConstraints {
            $0.top.equalTo(coverView.snp.bottom).offset(50)
            
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        horizontalActionMenuView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Self.horizontalActionMenuHeight)
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
