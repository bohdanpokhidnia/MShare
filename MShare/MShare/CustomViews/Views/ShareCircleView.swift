//
//  ShareCircleView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 12.09.2022.
//

import UIKit

final class ShareCircleView: View {
    
    // MARK: - UI
    
    private let gradientView = GradientView()
        .set(colors: [.appPink, .appPink, .appBlue, .appBlue])
        .set(startPoint: .topLeading, endPoint: .bottomTrailing)
    
    private let shareImageView = UIImageView()
        .setImage(UIImage(systemName: "square.and.arrow.up"))
        .tint(color: .white)
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        gradientView.addSubview(shareImageView)
        addSubview(gradientView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shareImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(all: 8))
        }
    }
    
}
