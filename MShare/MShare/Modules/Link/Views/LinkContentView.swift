//
//  LinkContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SnapKit

final class LinkContentView: View {
    
    var tapCopyButtonAction: (() -> Void) = {}
    
    // MARK: - UI
    
    private lazy var controlsStackView = makeStackView(
        axis: .vertical,
        distibution: .fillEqually,
        spacing: 16
    )(
        linkTextField,
        searchButton
    )
    
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var copyButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    
    private lazy var toolBar = UIToolbar(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 40)))
        .make {
            $0.items = [flexibleSpace, copyButton, flexibleSpace]
        }
    
    private(set) lazy var linkTextField = PaddedTextField()
        .make {
            $0.clearButtonMode = .whileEditing
            $0.placeholder = "Link for search song"
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
    
    private(set) var searchButton = Button(type: .system)
        .maskToBounds(true)
        .setCornerRadius(12)
        .backgroundColor(color: .systemBlue)
        .setTitle("Search")
        .setTitleColor(.white)
        .set(font: .systemFont(ofSize: 14, weight: .semibold))
        .set(colors: [.appPink, .appPink, .appBlue, .appBlue])
        .set(startPoint: .topLeading, endPoint: .trailing)
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .systemBackground)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(controlsStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        controlsStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.height.equalTo(112)
        }
    }
    
}

// MARK: - User interactions

private extension LinkContentView {
    
    @objc
    func didTapDoneButton() {
        tapCopyButtonAction()
    }
    
}

// MARK: - Set

extension LinkContentView {
    
    func setLinkText(_ text: String) {
        linkTextField.text = text
    }
    
    func setCopyButtonTitle(_ title: String) {
        copyButton.title = title
    }
    
    func enableSearchButton(_ enabled: Bool) {
        searchButton.isEnabled = enabled
    }
    
}
