//
//  ThirdPageViewController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.01.2023.
//

import UIKit
import AVKit

final class ThirdPageViewController: UIViewController {
    
    enum PreviewVideo: String {
        case appleMusic = "appleMusicExample"
        
        var url: URL {
            let resourceName = self.rawValue
            let resourceType = self.type
            guard let path = Bundle.main.path(forResource: resourceName, ofType: resourceType)
            else { fatalError("video not found") }
            
            return URL(fileURLWithPath: path)
        }
        
        var type: String {
            switch self {
            case .appleMusic:
                return "mov"
            }
        }
    }
    
    // MARK: - UI
    
    let bluredView = View()
        .addBlur(style: .dark)
    
    private let contentView = View()
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 16
    )(
        videoView,
        titleLabel
    )
    
    private let videoView = View()
    
    private let titleLabel = UILabel()
        .text("Easy share a link from your favorite music platform")
        .text(font: .onboardingDescription)
        .text(alignment: .center)
        .textColor(.white)
        .set(numberOfLines: 0)
    
    private lazy var player = AVPlayer(url: currentVideo.url)
    
    private lazy var backgroundPlayerLayer = AVPlayerLayer(player: player)
    private lazy var playerLayer = AVPlayerLayer(player: player)
    
    private var currentVideo: PreviewVideo = .appleMusic
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViews()
        defineLayout()
        
        setupBackgroundPlayerLayer()
        setupPlayerLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playVideoFromStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player.pause()
    }
    
    // MARK: - Deinitializers
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Setup

private extension ThirdPageViewController {
    
    func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPlayingVideo),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    func setupViews() {
        contentView.addSubview(contentStackView)
        view.addSubview(contentView)
    }
    
    func defineLayout() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 32))
            $0.bottom.equalToSuperview().inset(UIEdgeInsets(aBottom: 200))
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(aBottom: 16))
        }
    }
    
    func setupBackgroundPlayerLayer() {
        backgroundPlayerLayer.frame = view.frame
        view.layer.insertSublayer(backgroundPlayerLayer, at: 0)

        bluredView.frame = view.frame
        view.insertSubview(bluredView, at: 1)
    }
    
    func setupPlayerLayer() {
        playerLayer.frame = videoView.frame
        contentView.layer.addSublayer(playerLayer)
    }
    
}

// MARK: - User interactions

private extension ThirdPageViewController {
    
    @objc
    func didPlayingVideo() {
//        currentVideo = currentVideo == .appleMusic ? .spotify : .appleMusic
//
//        let playerItem = AVPlayerItem(url: currentVideo.url)
//        player.replaceCurrentItem(with: playerItem)
        
        playVideoFromStart()
    }
    
}

// MARK: - Private Methods

private extension ThirdPageViewController {
    
    func playVideoFromStart() {
        player.seek(to: .zero)
        player.isMuted = true
        player.play()
    }
    
}
