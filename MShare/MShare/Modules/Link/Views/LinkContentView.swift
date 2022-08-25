//
//  LinkContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SnapKit

final class LinkContentView: View {
    
    // MARK: - UI
    
    private lazy var controlsStackView = makeStackView(
        axis: .horizontal,
        spacing: 12
    )(
        linkTextField, searchButton
    )
    
    private(set) var linkTextField = UITextField()
        .make {
            $0.clearButtonMode = .whileEditing
            $0.placeholder = "Link for search song"
            $0.adjustsFontSizeToFitWidth = true
        }
    
    private(set) var searchButton = Button(type: .system)
        .maskToBounds(true)
        .setCornerRadius(6)
        .backgroundColor(color: .secondarySystemBackground)
        .make {
            $0.setTitle("Search", for: .normal)
        }
    
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
            $0.height.equalTo(35)
        }
        
        searchButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
    }
    
}

// MARK: - Set

extension LinkContentView {
    
    func setLinkText(_ text: String) {
        linkTextField.text = text
    }
    
}
