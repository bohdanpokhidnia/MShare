//
//  TwoPageViewController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 25.01.2023.
//

import UIKit

final class TwoPageViewController: UIViewController {
    
    // MARK: - UI
    
    private let contentView = View()
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 32
    ) (
        exchangeImageView,
        titleContainerView
    )
    
    private let exchangeImageView = UIImageView(image: UIImage(named: "exchange"))
        .setContentMode(.scaleAspectFit)
    
    private let titleContainerView = View()
    
    private let titleLabel = UILabel()
        .text("Quickly get a song link from Apple Music to Spotify and vice versa")
        .text(alignment: .center)
        .textColor(.white)
        .set(numberOfLines: 0)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        defineLayout()
    }
    
}

// MARK: - Setup

private extension TwoPageViewController {
    
    func setupViews() {
        titleContainerView.addSubview(titleLabel)
        contentView.addSubview(contentStackView)
        view.addSubview(contentView)
    }
    
    func defineLayout() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(UIEdgeInsets(aBottom: 200))
        }
        
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
        }
        
        exchangeImageView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 76))
        }
    }
    
}

