//
//  FavoritesContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

final class FavoritesContentView: View {
    
    // MARK: - UI
    
    private(set) lazy var favotitesTableView = TableView(style: .grouped)
        .register(class: MediaTableViewCell.self)
        .setRowHeight(80)
        .backgroundColor(color: .clear)
        .make {
            $0.scrollIndicatorInsets = UIEdgeInsets(aTop: 0, aBottom: 82)
            $0.contentInset = UIEdgeInsets(aBottom: 48)
        }
    
    private lazy var infoStackView = makeStackView(axis: .vertical)(
        infoImageView,
        infoLabel
    )
    
    private let infoImageView = UIImageView()
        .setImage(UIImage(named: "dog"))
        .setContentMode(.scaleAspectFit)
    
    private let infoLabel = UILabel()
        .set(numberOfLines: 1)
        .text("You haven't added any songs yet")
        .text(font: .systemFont(ofSize: 16, weight: .light))
        .text(alignment: .center)
        .textColor(.secondaryLabel)
    
    private(set) var segmentedControl = TTSegmentedControl()
        .make {
            $0.itemTitles = FavoritesView.FavoriteSection.allCases.map { $0.title }
            $0.allowChangeThumbWidth = false
            $0.useShadow = false
            $0.useGradient = true
            $0.thumbGradientColors = [.appPink, .appPink, .appBlue, .appBlue]
            $0.gradientStartPoint = GradientPoint.topLeading.point
            $0.gradientEndPoint = GradientPoint.bottomTrailing.point
            $0.isBlurBackground = true
        }
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        infoStackView.hidden(true)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubviews(
            favotitesTableView,
            infoStackView,
            segmentedControl
        )
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        favotitesTableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        infoImageView.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        infoStackView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
        }
        
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(aBottom: 16))
            $0.height.equalTo(50)
        }
    }
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        
        let favorites = theme.components.favorites
        let themeSegmentControl = favorites.segmentControl
        
        segmentedControl.make {
            $0.defaultTextColor = themeSegmentControl.normal.color
            $0.defaultTextFont = themeSegmentControl.normal.font
            $0.selectedTextColor = themeSegmentControl.active.color
            $0.selectedTextFont = themeSegmentControl.active.font
            $0.containerBackgroundColor = themeSegmentControl.background.color
        }
        
        set(component: favorites.background)
    }
    
}

// MARK: - Set

extension FavoritesContentView {
    
    @discardableResult
    func showEmptyInfo(_ show: Bool) -> Self {
        infoStackView.hidden(!show)
        return self
    }
    
    @discardableResult
    func set(infoText: String) -> Self {
        infoLabel.text = infoText
        return self
    }
    
}

