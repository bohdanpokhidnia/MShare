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
    
    private(set) lazy var controlsWidth = UIScreen.main.bounds.width - controlsPadding * 2
    let controlsHeight: CGFloat = 48
    let controlsPadding: CGFloat = 16
    
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var copyButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    
    private lazy var toolBar = UIToolbar(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: toolBarHeight)))
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
        
        backgroundColor(color: .systemBackground)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubviews(linkTextField, searchButton)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        let controlsSize = CGSize(width: controlsWidth, height: controlsHeight)

        linkTextField.frame = .init(origin: .init(x: controlsPadding, y: center.y + controlsHeight + controlsSpacing),
                                    size: controlsSize)
        searchButton.frame = .init(origin: .init(x: controlsPadding, y: linkTextField.frame.origin.y + controlsHeight + controlsSpacing),
                                   size: controlsSize)
        
        searchButton.bounds = searchButton.frame
    }
    
    private let controlsSpacing: CGFloat = 16
    private(set) var toolBarHeight: CGFloat = 40
    
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
