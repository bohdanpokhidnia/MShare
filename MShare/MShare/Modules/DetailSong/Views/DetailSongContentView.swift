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
    
    static let horizontalActionMenuHeight: CGFloat = 130
    
    struct State {
        let coverURL: String
        let artistName: String
        let songName: String
    }
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView()
        .setContentMode(.center)
        .addBlur()
    
    private let coverView = CoverView()
    
    private let horizontalActionMenuContainer = View()
        .setCornerRadius(12)
        .maskToBounds(true)
        .backgroundColor(color: .white)
    
    private(set) var horizontalActionMenuView = HorizontalActionMenuView()
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
    
        horizontalActionMenuContainer.addSubview(horizontalActionMenuView)
        addSubviews(backgroundImageView, coverView, horizontalActionMenuContainer)
    }
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .red)
        maskToBounds(true)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        horizontalActionMenuContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(Self.horizontalActionMenuHeight)
        }
        
        horizontalActionMenuView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
