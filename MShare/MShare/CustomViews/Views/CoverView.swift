//
//  CoverView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.08.2022.
//

import UIKit
import SnapKit

typealias CoverViewAnimation = CoverView.AnimationState

final class CoverView: ViewLayoutable {
    var onTap: (() -> Void) = { }
    
    enum AnimationState {
        case pressed
        case unpressed
        
        var animation: CGAffineTransform {
            switch self {
            case .pressed:
                return .identity.scaledBy(x: 0.95, y: 0.95)
                
            case .unpressed:
                return .identity
            }
        }
    }
    
    // MARK: - UI
    
    private let containerView = UIView()
        .setOnly(cornerRadius: 28.0, topLeft: true, topRight: true)
        .maskToBounds(true)
    
    private(set) var gradientBackgroundView = GradientView()
        .set(colors: [.appPink, .appPink, .appBlue, .appBlue])
        .set(startPoint: .topLeading, endPoint: .bottomTrailing)
        .setOnly(cornerRadius: 16.0, bottomLeft: true, bottomRight: true)
        .maskToBounds(true)
    
    private lazy var contentStackView = makeStackView(
        .vertical,
        spacing: 8
    )(
        coverImageView,
        textStackView
    )
    
    private(set) var coverImageView = UIImageView()
        .setContentMode(.scaleToFill)
        .backgroundColor(color: .systemBlue)
        .setCornerRadius(12)
        .maskToBounds(true)
        .borderWidth(1, color: .black)
    
    private lazy var textStackView = makeStackView(axis: .vertical)(
        songNameLabel,
        artistNameLabel
    )
    
    private(set) var songNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 32, weight: .bold))
        .text(alignment: .center)
        .textColor(.white)
        .set(numberOfLines: 2)
        .adjustsFontSizeToFitWidth(true)
        .make {
            $0.minimumScaleFactor = 0.2
        }
    
    private(set) var artistNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 20, weight: .regular))
        .text(alignment: .center)
        .textColor(UIColor(hex: "#f0f0f0"))
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
        .make {
            $0.minimumScaleFactor = 0.2
        }
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        gradientBackgroundView.addSubview(contentStackView)
        containerView.addSubview(gradientBackgroundView)
        addSubview(containerView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.bottom.equalTo(-16)
        }
        
        coverImageView.snp.makeConstraints {
            $0.width.height.equalTo(coverImageWidth)
        }
    }
    
    // MARK: - Private
    
    private let coverViewTopOffset: CGFloat = 16
    private let labelsViewTopOffset: CGFloat = 4
    private let viewBottomOffset: CGFloat = 22
    private let coverImageWidth: CGFloat = UIApplication.windowScene.screen.bounds.width / 1.5
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCoverView))
    
}

// MARK: - User interactions

private extension CoverView {
    @objc
    func didTapCoverView() {
        onTap()
    }
}

// MARK: - Set

extension CoverView {
    @discardableResult
    func set(state: SongDetailsEntity) -> Self {
        coverImageView.setImage(state.image)
        songNameLabel.text(state.songName)
        artistNameLabel.text(state.artistName)
        return self
    }
}

@available(iOS 17.0, *)
#Preview {
    CoverView()
        .set(state: .init(
            songName: "Test Test Test Test Test Test Test Test Test Test Test Test Test",
            artistName: "Artist name",
            image: .mockCover,
            sourceURL: "",
            services: []
        ))
}
