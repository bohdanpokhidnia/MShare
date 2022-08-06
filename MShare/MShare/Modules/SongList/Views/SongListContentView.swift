//
//  SongListContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import UIKit
import SnapKit

class SongListContentView: View {
    
    // MARK: - UI
    
    private let contentView = View()
    
    private(set) var songsTableView = MediaTableView(tableViewStyle: .insetGrouped)
        .set(rowHeight: 80)
        .set(inset: UIEdgeInsets(aLeft: MediaTableViewCell.iconImageContainerWidth))
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .systemBackground)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        contentView.addSubview(songsTableView)
        addSubview(contentView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(safeAreaInsets)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        songsTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

