//
//  ServicesTableView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

final class ServicesTableView: View {
    
    // MARK: - UI
    
    private(set) lazy var tableView = TableView()
        .register(class: MediaTableViewCell.self)
        .setRowHeight(80)
        .set(inset: .init(aLeft: MediaTableViewCell.iconImageContainerWidth))
        .enableScroll(false)
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(tableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
