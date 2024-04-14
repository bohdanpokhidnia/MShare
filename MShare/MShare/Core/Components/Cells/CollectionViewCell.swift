//
//  CollectionViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, ViewLayoutableProtocol {
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupSubviews()
        defineLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLayoutableProtocol
    
    func setup() {
        
    }
    
    func setupSubviews() {
        
    }
    
    func defineLayout() {
        
    }
}
