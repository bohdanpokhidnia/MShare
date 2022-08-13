//
//  CoverView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.08.2022.
//

import UIKit
import SnapKit

final class CoverView: View {
    
    // MARK: - UI
    
    private let contentView = UIView()
        .setCornerRadius(12)
        .maskToBounds(true)
        .backgroundColor(color: .white)
    
    private let coverImageView = UIImageView()
        .setContentMode(.scaleToFill)
        .backgroundColor(color: .gray)
        .setCornerRadius(10)
        .maskToBounds(true)
        .borderWidth(1, color: .black)
    
    private lazy var namesLabelStackView = makeStackView(axis: .vertical)(
        songNameLabel,
        artistNameLabel
    )
    
    private(set) var songNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 32, weight: .bold))
        .text(alignment: .center)
        .textColor(.black)
        .set(numberOfLines: 2)
        .adjustsFontSizeToFitWidth(true)
    
    private let artistNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 22, weight: .regular))
        .text(alignment: .center)
        .textColor(.black)
        .set(numberOfLines: 2)
        .adjustsFontSizeToFitWidth(true)
    
    override var intrinsicContentSize: CGSize {
        let width: CGFloat = coverImageWidth + 16 * 2
        
        namesLabelStackView.layoutIfNeeded()
        let labelsHeight = namesLabelStackView.frame.height
        let height: CGFloat = coverImageWidth + labelsHeight + coverViewTopOffset + labelsViewTopOffset + viewBottomOffset
        
        return .init(width: width, height: height)
    }
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        contentView.addSubviews(coverImageView, namesLabelStackView)
        addSubview(contentView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(coverImageWidth)
        }
        
        namesLabelStackView.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(10)
            $0.leading.equalTo(coverImageView.snp.leading)
            $0.trailing.equalTo(coverImageView.snp.trailing)
        }
    }
    
    // MARK: - Private
    
    private let coverViewTopOffset: CGFloat = 16
    private let labelsViewTopOffset: CGFloat = 4
    private let viewBottomOffset: CGFloat = 16
    private let coverImageWidth: CGFloat = UIScreen.main.bounds.width / 1.5
    
}

// MARK: - Set

extension CoverView {
    
    @discardableResult
    func set(state: DetailSongState) -> Self {
        coverImageView.setImage(state.coverURL)
        songNameLabel.text(state.songName)
        artistNameLabel.text(state.artistName)
        
        return self
    }
    
}
