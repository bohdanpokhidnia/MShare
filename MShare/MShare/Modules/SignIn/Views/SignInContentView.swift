//
//  SignInContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit
import AuthenticationServices

final class SignInContentView: ViewLayoutable {
    
    // MARK: - UI
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical
    )(
        titleStackView,
        collectionContainerView,
        buttonsStackView
    )
    
    private lazy var titleStackView = makeStackView(
        axis: .vertical,
        spacing: 2
    )(
        welcomeLabel,
        appLabel
    )
    
    private let welcomeLabel = UILabel()
        .text("Welcome to")
        .text(font: .boldSystemFont(ofSize: 38))
        .text(alignment: .center)
    
    private let appLabel = UILabel()
        .text("MShare")
        .text(font: .boldSystemFont(ofSize: 38))
        .text(alignment: .center)
    
    private let collectionContainerView = ViewLayoutable()
    
    private(set)lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(class: SignInCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var buttonsStackView = makeStackView(
        axis: .vertical
    )(
        privacyPolicyButton,
        blackAppleButton,
        whiteAppleButton,
        skipButton
    )
    
    private(set) var privacyPolicyButton = Button()
        .set(font: .onboardingDescription)
        .setTitle("Privacy policy")
        .setTitleColor(.tertiaryLabel)
    
    private(set) var blackAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    private(set) var whiteAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    
    private(set) var skipButton = Button()
        .set(font: .onboardingAction)
        .setTitle("Skip")
        .setTitleColor(.appBlue)
    
    // MARK: - Lifecycle

    override func setupSubviews() {
        super.setupSubviews()
    
        backgroundColor(color: .systemBackground)
        
        collectionContainerView.addSubview(collectionView)
        addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(aTop: 100, aBottom: 16))
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
        }

        collectionView.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        [privacyPolicyButton,
         blackAppleButton,
         whiteAppleButton,
         skipButton].forEach { (button) in
            button.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }
    }
    
}

