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
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 10
    )(
        controlsContainerView,
        servicesTableView,
        View()
    )
    
    private let controlsContainerView = View()
    
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
    
    private(set) var servicesTableView = MediaTableView(tableViewStyle: .grouped)
        .set(rowHeight: 80)
        .set(inset: .init(aLeft: MediaTableViewCell.iconImageContainerWidth))
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .systemBackground)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        controlsContainerView.addSubview(controlsStackView)
        addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        controlsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(aTop: 16, aLeft: 16, aRight: 16))
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
