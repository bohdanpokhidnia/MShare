//
//  FavoritesContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

final class FavoritesContentView: View {
    
    private(set) lazy var favotitesTableView = TableView(style: .insetGrouped)
        .register(class: MediaTableViewCell.self)
        .setRowHeight(80)
    
    // MARK: - Lifecycle

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(favotitesTableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        favotitesTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

