//
//  SearchContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SnapKit

final class SearchContentView: ViewLayoutable {
    var tapCopyButtonAction: (() -> Void) = {}
    
    // MARK: - UI
    
    private let flexibleSpace = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil
    )
    private lazy var copyButton = UIBarButtonItem(
        title: "Done",
        style: .done,
        target: self,
        action: #selector(didTapDoneButton)
    )
    private lazy var toolBar = UIToolbar(frame: .init(
        origin: .zero,
        size: .init(
            width: UIApplication.windowScene.screen.bounds.width,
            height: toolBarHeight
        )
    ))
    .make {
        $0.items = [flexibleSpace, copyButton, flexibleSpace]
    }
    
    private(set) lazy var linkTextField = PaddedTextField()
        .make {
            $0.clearButtonMode = .whileEditing
            $0.placeholder = "Link on song or album"
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.adjustsFontSizeToFitWidth = true
            $0.textInsets = .init(aLeft: 16, aRight: 24)
            $0.customCornerRadius = 12
            $0.borderWidth = 1
            $0.borderColor = .appGray
            $0.inputAccessoryView = toolBar
            $0.inputAccessoryView?.isHidden = true
            $0.returnKeyType = .search
        }
    
    private(set) var searchButton = LoadingButton(type: .custom)
        .maskToBounds(true)
        .setCornerRadius(12)
        .backgroundColor(color: .clear)
        .setTitle("Search")
        .setTitleColor(.white)
        .set(font: .systemFont(ofSize: 14, weight: .semibold))
        .set(colors: [.appPink, .appPink, .appBlue, .appBlue])
        .set(startPoint: .topLeading, endPoint: .trailing)
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.tapGesture = tapGesture
        
        addGestureRecognizer(tapGesture)
        backgroundColor(color: .systemBackground)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubviews(linkTextField, searchButton)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        linkTextField.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(searchButton.snp.top).offset(-16)
            $0.height.equalTo(48)
        }
        
        searchButton.snp.makeConstraints {
            buttonTopConstraint = $0.top.equalTo(snp.centerY).offset(8).constraint
            buttonCenterXconstrait = $0.centerX.equalToSuperview().constraint
            buttonWidthConstraint = $0.width.equalToSuperview().inset(16.0).constraint
            buttonHeightConstraint = $0.height.equalTo(buttonHeight).constraint
        }
    }
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        
        let link = theme.components.link
        
        set(component: link.background)
    }
    
    // MARK: - Private
    
    private var toolBarHeight: CGFloat = 40.0
    private var buttonHeight: CGFloat = 48.0
    private var buttonTopConstraint: Constraint?
    private var buttonCenterXconstrait: Constraint?
    private var buttonWidthConstraint: Constraint?
    private var buttonHeightConstraint: Constraint?
    private var tapGesture: UITapGestureRecognizer?
}

// MARK: - User interactions

private extension SearchContentView {
    @objc
    func didTap() {
        endEditing(true)
    }
    
    @objc
    func didTapDoneButton() {
        tapCopyButtonAction()
    }
}

// MARK: - Private Methods

private extension SearchContentView {
    func applyLayoutAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    func hiddenTextField(isHidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.linkTextField.alpha = isHidden ? 0.0 : 1.0
            })
        } else {
            linkTextField.alpha = isHidden ? 0.0 : 1.0
        }
    }
}

// MARK: - Set

extension SearchContentView {
    func setLinkText(_ text: String) {
        linkTextField.text = text
    }
    
    func setCopyButtonTitle(_ title: String) {
        copyButton.title = title
    }
    
    func enableSearchButton(_ enabled: Bool) {
        searchButton.isEnabled = enabled
    }
    
    func setSearchButton(y: CGFloat) {
        buttonTopConstraint?.deactivate()
        
        searchButton.snp.remakeConstraints {
            $0.top.equalTo(y)
        }
        
        buttonCenterXconstrait?.activate()
        buttonWidthConstraint?.activate()
        buttonHeightConstraint?.activate()
        
        applyLayoutAnimation()
    }
    
    func resetSearchButtonPosition() {
        searchButton.snp.removeConstraints()
        
        buttonTopConstraint?.activate()
        buttonCenterXconstrait?.activate()
        buttonWidthConstraint?.activate()
        buttonHeightConstraint?.activate()
        
        applyLayoutAnimation()
    }
    
    func set(
        loadingAnimationState: LoadingButton.AnimationState,
        completion: (() -> Void)? = nil
    ) {
        hiddenTextField(isHidden: loadingAnimationState == .start, animated: true)
        searchButton.set(animationState: loadingAnimationState)
        
        switch loadingAnimationState {
        case .start:
            searchButton.layer.cornerRadius = 24.0
            buttonTopConstraint?.deactivate()
        
            searchButton.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                buttonWidthConstraint = $0.width.equalTo(searchButton.snp.height).constraint
            }
            
            buttonCenterXconstrait?.activate()
            buttonHeightConstraint?.activate()
            
        case .end:
            searchButton.layer.cornerRadius = 12.0
            
            searchButton.snp.remakeConstraints {
                buttonWidthConstraint = $0.width.equalToSuperview().inset(16.0).constraint
            }
            
            buttonTopConstraint?.activate()
            buttonCenterXconstrait?.activate()
            buttonHeightConstraint?.activate()
        }
        
        applyLayoutAnimation(completion: completion)
    }
}
