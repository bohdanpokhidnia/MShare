//
//  DetailSongContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import SnapKit

typealias DetailSongState = DetailSongContentView.State

final class DetailSongContentView: View {
    
    struct State {
        let coverURL: String
        let artistName: String
        let songName: String
    }
    
    // MARK: - UI
    
    private lazy var contentStack = makeStackView(
        axis: .vertical,
        spacing: 16
    )(
        imageContainer,
        songNameContainer,
        View()
    )
    
    private let imageContainer = View()
    
    private let coverImageView = UIImageView()
        .setContentMode(.scaleToFill)
        .backgroundColor(color: .gray)

    private lazy var imageBottomStackView = makeStackView(
        axis: .horizontal,
        spacing: 10
    ) (
        artistNameLabel, View(), shareButton
    )
    
    private let artistNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 32, weight: .black))
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
        .textColor(.black)
    
    private(set) var shareButton = Button(type: .system)
        .setImage(UIImage(systemName: "square.and.arrow.up.circle.fill"))
        .make {
            $0.contentHorizontalAlignment = .fill
            $0.contentVerticalAlignment = .fill
        }
    
    private let songNameContainer = View()
    
    private let songNameLabel = UILabel()
        .text(font: .systemFont(ofSize: 22, weight: .light))
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .systemBackground)
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        imageContainer.addSubviews(coverImageView, imageBottomStackView)
        songNameContainer.addSubview(songNameLabel)
        addSubview(contentStack)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageContainer.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        
        coverImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        imageBottomStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.bottom.equalToSuperview().inset(UIEdgeInsets(aBottom: 16))
        }
        
        songNameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
        }
    }
    
}

// MARK: - Set

extension DetailSongContentView {
    
    @discardableResult
    func set(state: State) -> Self {
        coverImageView.setImage(state.coverURL, placeholder: nil)
        
        artistNameLabel.text(state.artistName.uppercased())
        
        songNameLabel.text(state.songName)
        return self
    }
    
}
