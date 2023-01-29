//
//  FirstPageViewController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

final class FirstPageViewController: UIViewController {
    
    // MARK: - UI
    
    private let contentView = View()
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 12
    )(
        logoImageView,
        titleLabel,
        descriptionLabel
    )
    
    private let logoImageView = UIImageView(image: .init(named: "logo"))
        .setContentMode(.scaleAspectFit)
    
    private let titleLabel = UILabel()
        .text("MShare")
        .text(font: .appName)
        .text(alignment: .center)
        .textColor(.white)
    
    private let descriptionLabel = UILabel()
        .text("First mobile application, who give availability share songs between music platforms")
        .text(font: .onboardingDescription)
        .text(alignment: .center)
        .set(numberOfLines: 0)
        .textColor(.white)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(contentStackView)
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(UIEdgeInsets(aBottom: 200))
        }
        
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 64))
            $0.centerY.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(245)
        }
    }
    
}
