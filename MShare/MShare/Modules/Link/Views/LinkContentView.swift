//
//  LinkContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SnapKit

class LinkContentView: View {
    
    var searchOnLinkAction: (() -> Void) = { }
    
    // MARK: - UI
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 10
    )(
        controlsStackView,
        servicesTableView,
        View()
    )
    
    private lazy var controlsStackView = makeStackView(
        axis: .horizontal,
        spacing: 12
    )(
        linkTextField, searchButton
    )
    
    private(set) var linkTextField = UITextField()
        .make {
            $0.placeholder = "Link for search song"
            $0.adjustsFontSizeToFitWidth = true
        }
    
    private lazy var searchButton = UIButton(type: .system)
        .maskToBounds(true)
        .setCornerRadius(6)
        .make {
            $0.setTitle("Search", for: .normal)
            $0.backgroundColor = .secondarySystemBackground
            $0.addTarget(self, action: #selector(didTapSearchButton(_:)), for: .touchUpInside)
        }
    
    private(set) var servicesTableView = ServicesTableView()
    
    // MARK: - Lifecycle

    override func setupSubviews() {
        super.setupSubviews()
        
        backgroundColor = .systemBackground
        addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(aTop: 16))
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
    }
    
}

// MARK: - User interactions

private extension LinkContentView {
    
    @objc
    func didTapSearchButton(_ sender: UIButton) {
        searchOnLinkAction()
    }
    
}

// MARK: - Set

extension LinkContentView {
    
    func setLinkText(_ text: String) {
        linkTextField.text = text
    }
    
    func closeKeyboard() {
        linkTextField.resignFirstResponder()
    }
    
}
