//
//  DetailSongContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import SnapKit
import NotificationToast

final class DetailSongContentView: View {
    
    // MARK: - UI
    
    private(set) var copiedToast = ToastView(title: "Cover copied",
                                             titleFont: .systemFont(ofSize: 13, weight: .regular),
                                             icon: UIImage(systemName: "doc.on.doc.fill"),
                                             iconSpacing: 16,
                                             position: .top)
    
    private(set) var unvailableToast = ToastView(title: "The service will be available soon",
                                                 titleFont: .systemFont(ofSize: 13, weight: .regular),
                                                 icon: UIImage(systemName: "xmark"),
                                                 iconSpacing: 12,
                                                 position: .top)
    
    private(set) var imageSavedToast = ToastView(title: "Image saved successfuly",
                                                 titleFont: .systemFont(ofSize: 13, weight: .regular),
                                                 icon: UIImage(systemName: "photo.on.rectangle.angled"),
                                                 iconSpacing: 14,
                                                 position: .top)
    
    private let backgroundImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .addClearBackgroundBlur(style: .regular)
    
    private let coverViewContainer = View()
        .maskToBounds(false)
        .setCornerRadius(28)
        .addShadow(color: .black, offset: .init(width: 4, height: 4), opacity: 0.3, radius: 10)
    
    private(set) var coverView = CoverView()
    
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
            
            defineLayoutForHorizontalMenu($0, forPhone: UIDevice.phone)
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
    
    @discardableResult
    func set(animationState: CoverViewAnimation, completion: (() -> Void)? = nil) -> Self {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5,
                       options: [.allowUserInteraction],
                       animations: {
            
            self.coverViewContainer.transform = animationState.animation
        }, completion: { _ in
            completion?()
        })
        
        return self
    }
    
    func makeImage() -> UIImage? {
        horizontalActionMenuView.isHidden = true
        
        let oldCoverCenter = coverViewContainer.center
        coverViewContainer.center = center
        
        defer {
            horizontalActionMenuView.isHidden = false
            coverViewContainer.center = oldCoverCenter
        }
        
        let snapshotImage = makeSnapShotImage(withBackground: true)
        return snapshotImage
    }
    
}

// MARK: - Private Methods

private extension DetailSongContentView {
    
    func defineLayoutForCoverView(_ constraint: ConstraintMaker, forPhone phone: UIDevice.Phone) {
        switch phone {
        case .iPhoneSE:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
            
//        case .iPhone6_7_8_SE2_SE3
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8/*, .simulator*/:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(10)
            
//        case .iPhone6_7_8Plus:
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            constraint.centerY.equalToSuperview().offset(-80)
            
//        case .iPhoneXr_XsMax_11_12, .iPhone12Pro_13_13Pro_14, .iPhoneX_11Pro_12Mini_13Mini, .iPhone12_13ProMax_14Plus, .iPhone14Pro, .iPhone14ProMax:
        case .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11ProMax, .iPhone12, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Pro, .iPhone14, .iPhoneX, .iPhone11Pro, .iPhone12Mini, .iPhone13Mini, .iPhone13ProMax, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax:
            constraint.centerY.equalToSuperview().offset(-100)
            
        case .simulator, .unrecognized:
            constraint.top.equalTo(safeAreaLayoutGuide).offset(60)
        }
    }
    
    func defineLayoutForHorizontalMenu(_ constraint: ConstraintMaker, forPhone phone: UIDevice.Phone) {
        var bottomOffset: CGFloat
        var height: CGFloat
        
        switch UIDevice.phone {
        case .iPhoneSE, .iPhone6, .iPhone6S, .iPhone7, .iPhone8/*, .simulator*/:
            bottomOffset = 0
            height = HorizontalActionMenuView.HorizontalActionMenuHeight + 30
            
        default:
            bottomOffset = -20
            height = HorizontalActionMenuView.HorizontalActionMenuHeight + 50
        }
        
        constraint.bottom.equalTo(safeAreaLayoutGuide).offset(bottomOffset)
        constraint.height.equalTo(height)
    }
    
}
