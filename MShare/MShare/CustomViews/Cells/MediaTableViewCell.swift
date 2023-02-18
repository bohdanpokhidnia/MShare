//
//  MediaTableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.08.2022.
//

import UIKit
import SnapKit

protocol MediaItemDelegate: AnyObject {
    func didTapShareButton(_ indexPath: IndexPath)
}

typealias MediaItem = MediaTableViewCell.State

final class MediaTableViewCell: TableViewCell {
    
    static let iconImageContainerWidth: CGFloat = 80
    
    struct State {
        let title: String
        let subtitle: String?
        let positionNumber: String?
        let imageURL: String?
        let defaultPlaceholder: UIImage?
        let displayShareButton: Bool
        
        init(title: String,
             subtitle: String? = nil,
             positionNumber: String? = nil,
             imageURL: String? = nil,
             defaultPlaceholder: UIImage? = nil,
             displayShareButton: Bool = false) {
            self.title = title
            self.subtitle = subtitle
            self.positionNumber = positionNumber
            self.imageURL = imageURL
            self.defaultPlaceholder = defaultPlaceholder
            self.displayShareButton = displayShareButton
        }
        
    }
    
    // MARK: - UI
    
    private lazy var contentStackView = makeStackView(
        axis: .horizontal
    )(
        iconImageContainerView, positionNumberView, labelsView, View(), shareButton
    )

    private let iconImageContainerView = View()
    
    private let iconImageView = UIImageView()
        .setContentMode(.scaleAspectFit)
    
    private let positionNumberView = View()
    
    private let positionNumberLabel = UILabel()
        .set(numberOfLines: 1)
        .text(alignment: .center)
    
    let labelsView = View()
    
    private lazy var labelsStackView = makeStackView(
        axis: .vertical,
        distibution: .fillProportionally
    )(
        titleLabel,
        subtitileLabel
    )
    
    private let titleLabel = UILabel()
        .set(numberOfLines: 1)
    
    private let subtitileLabel = UILabel()
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
    
    private let shareButton = Button(type: .system)
        .setImage(UIImage(systemName: "square.and.arrow.up"))
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        shareButton.whenTap { [weak self] in
            guard let indexPath = self?.cellIndexPath else { return }
            
            self?.delegate?.didTapShareButton(indexPath)
        }
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        iconImageContainerView.addSubview(iconImageView)
        positionNumberView.addSubview(positionNumberLabel)
        labelsView.addSubviews(labelsStackView)
        contentView.addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageContainerView.snp.makeConstraints {
            $0.width.equalTo(Self.iconImageContainerWidth)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        positionNumberLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(25)
        }
        
        labelsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        shareButton.snp.makeConstraints {
            $0.width.equalTo(50)
        }
    }
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        
        let mediaCell = theme.components.mediaCell
        
        iconImageView.set(component: mediaCell.icon)
        titleLabel.set(component: mediaCell.title)
        subtitileLabel.set(component: mediaCell.subtitle)
        set(component: mediaCell.background)
    }
    
    // MARK: - Private
    
    private var cellIndexPath: IndexPath? = nil
    private weak var delegate: MediaItemDelegate?
    private var titleLabelCenterY: ConstraintMakerEditable?
    
}

// MARK: - Set

extension MediaTableViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        contentStackView.setCustomSpacing(state.positionNumber == nil ? 0 : 10, after: positionNumberView)
        
        positionNumberView.hidden(state.positionNumber == nil)
        
        positionNumberLabel
            .text(state.positionNumber)
            .hidden(state.positionNumber == nil)
        
        titleLabel
            .text(state.title)
        
        subtitileLabel
            .text(state.subtitle)
            .hidden(state.subtitle == nil)
        
        if let imageURL = state.imageURL {
            iconImageView.setImage(imageURL, placeholder: nil)
        } else {
            iconImageView.setImage(state.defaultPlaceholder)
        }
        
        shareButton.hidden(!state.displayShareButton)
        return self
    }
    
    @discardableResult
    func set(delegate mediaItemDelegate: MediaItemDelegate, indexPath: IndexPath) -> Self {
        cellIndexPath = indexPath
        delegate = mediaItemDelegate
        return self
    }
    
}
