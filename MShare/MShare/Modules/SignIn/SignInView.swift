//
//  SignInView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit
import AuthenticationServices

protocol SignInViewProtocol: ASAuthorizationControllerPresentationContextProviding {
    var presenter: SignInPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    
    func dismissView(actionHandler: (() -> Void)?)
}

final class SignInView: ViewController<SignInContentView> {
    
    var presenter: SignInPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupActionHandlers()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let currentStyle = UITraitCollection.current.userInterfaceStyle
        guard previousTraitCollection?.userInterfaceStyle != currentStyle else { return }
        
        setupAppleSignInButton(withStyle: currentStyle)
    }
    
    // MARK: - Private

    private let emojiSize = CGSize(width: 40, height: 40)
    private lazy var informations: [SignInCollectionViewCell.State] = [
        .init(image: "🚀".toImage(size: emojiSize),
              title: "Sharing",
              subtitle: "Availability share songs between music platforms."),
        .init(image: "⚡️".toImage(size: emojiSize),
              title: "Fast",
              subtitle: "Quickly get a song link from Apple Music to Spotify and vice versa."),
        .init(image: "👌".toImage(size: emojiSize),
              title: "Easily",
              subtitle: "Share a link from your favorite music platform.")
    ]

}

// MARK: - Setup
private extension SignInView {
    
    func setupViews() {
        contentView.collectionView
            .dataSourced(self)
            .delegated(self)
        
        let style = traitCollection.userInterfaceStyle
        setupAppleSignInButton(withStyle: style)
    }
    
    func setupAppleSignInButton(withStyle style: UIUserInterfaceStyle) {
        contentView.blackAppleButton.isHidden = style == .dark
        contentView.whiteAppleButton.isHidden = style == .light
    }
    
    func setupActionHandlers() {
        contentView.privacyPolicyButton.onTap { [weak presenter] in
            presenter?.didTapPrivacyPolicy()
        }
        
        [contentView.blackAppleButton, contentView.whiteAppleButton].forEach {
            $0.addTarget(self, action: #selector(didTapSignInWithApple), for: .touchUpInside)
        }
        
        contentView.skipButton.onTap { [weak presenter] in
            presenter?.didTapSkip()
        }
    }
    
}

// MARK: - User interactions

private extension SignInView {
    
    @objc
    func didTapSignInWithApple() {
        presenter?.didTapSignInWithApple()
    }
    
}


// MARK: - SignInViewProtocol

extension SignInView: SignInViewProtocol {
    
    func dismissView(actionHandler: (() -> Void)?) {
        dismiss(animated: true, completion: actionHandler)
    }
    
}

//MARK: - UICollectionViewDataSource

extension SignInView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return informations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let info = informations[indexPath.row]
        let cell = collectionView.dequeue(SignInCollectionViewCell.self, for: indexPath)
        return cell.set(state: info)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SignInView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 60)
    }
    
}

//MARK: - ASAuthorizationControllerPresentationContextProviding

extension SignInView: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}
