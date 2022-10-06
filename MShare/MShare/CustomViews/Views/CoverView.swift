//
//  CoverView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.08.2022.
//

import UIKit
import SnapKit

final class CoverView: View {
    
    var whenTap: (() -> Void) = { }
    
    // MARK: - UI
    
    private let gradientBackgroundView = GradientView()
        .set(colors: [.appPink, .appPink, .appBlue, .appBlue])
        .set(startPoint: .topLeading, endPoint: .bottomTrailing)
        .setCornerRadius(28)
        .maskToBounds(true)
    
    private let coverImageView = UIImageView()
        .setContentMode(.scaleToFill)
        .backgroundColor(color: .systemBlue)
        .setCornerRadius(12)
        .maskToBounds(true)
        .borderWidth(1, color: .black)
    
    private lazy var namesLabelStackView = makeStackView(axis: .vertical)(
        songNameLabel,
        artistNameLabel
    )
    
    private(set) var songNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 32, weight: .bold))
        .text(alignment: .center)
        .textColor(.white)
        .set(numberOfLines: 2)
        .adjustsFontSizeToFitWidth(true)
    
    private let artistNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 20, weight: .regular))
        .text(alignment: .center)
        .textColor(UIColor(hex: "#f0f0f0"))
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
    
    override var intrinsicContentSize: CGSize {
        let width: CGFloat = coverImageWidth + 16 * 2
        
        namesLabelStackView.layoutIfNeeded()
        let labelsHeight = namesLabelStackView.frame.height
        let height: CGFloat = coverImageWidth + labelsHeight + coverViewTopOffset + labelsViewTopOffset + viewBottomOffset
        
        return .init(width: width, height: height)
    }
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        gradientBackgroundView.addSubviews(coverImageView, namesLabelStackView)
        addSubview(gradientBackgroundView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        gradientBackgroundView.snp.makeConstraints {
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
    private let viewBottomOffset: CGFloat = 22
    private let coverImageWidth: CGFloat = UIScreen.main.bounds.width / 1.5
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCoverView))
    
}

// MARK: - User interactions

private extension CoverView {
    
    @objc
    func didTapCoverView() {
        whenTap()
    }
    
}

// MARK: - Set

extension CoverView {
    
    @discardableResult
    func set(state: DetailSongEntity) -> Self {
        coverImageView.setImage(state.image)
        songNameLabel.text(state.songName)
        artistNameLabel.text(state.artistName)
        
        return self
    }
    
}
