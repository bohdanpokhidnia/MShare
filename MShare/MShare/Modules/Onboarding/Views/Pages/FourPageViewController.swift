//
//  FourPageViewController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit

final class FourPageViewController: UIViewController {
    
    // MARK: - UI
    
    private let contentView = View()
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 32
    )(
        imageView,
        titleLabel,
        View()
    )
    
    private let imageView = UIImageView(image: UIImage(named: "ukraine"))
        .setContentMode(.scaleAspectFill)
    
    private let titleLabel = UILabel()
        .text("Ukraine is currently suffering from the most destructive war since World War II, which is a purely colonial war with no justifications, as Russia is bombing Ukrainian infrastructure, destroying Ukrainian cities and killing civilians, and it's important to support Ukraine and its army by spreading information about the crimes of the Russians and calling for greater support. Ukraine will win.")
        .text(font: .onboardingDescription)
        .text(alignment: .natural)
        .textColor(.white)
        .enableMultilines()
        .make {
            $0.lineBreakMode = .byTruncatingTail
        }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        defineLayout()
    }
    
}

// MARK: - Setup

private extension FourPageViewController {
    
    func setupViews() {
        contentView.addSubview(contentStackView)
        view.addSubview(contentView)
    }
    
    func defineLayout() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.bottom.equalToSuperview().inset(UIEdgeInsets(aBottom: 200))
        }
        
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
    }
    
}
