//
//  SettingsContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

final class SettingsContentView: View {
    
    private(set) lazy var settingsTableView = TableView(style: .insetGrouped)
        .register(class: SettingsTableViewCell.self)
        .make { $0.isScrollEnabled = false }
    
    // MARK: - Lifecycle

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(settingsTableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        settingsTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

