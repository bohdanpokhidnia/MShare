//
//  HorizontalMenuAction.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2024.
//

import UIKit

enum HorizontalMenuAction: String, CaseIterable {
    case shareAppleMusicLink = "AppleMusic"
    case shareSpotifyLink = "Spotify"
    case shareYouTubeMusicLink = "YoutubeMusic"
    case shareCover
    case saveCover
    
    var image: UIImage {
        switch self {
        case .shareAppleMusicLink: .appleMusicLogo
        case .shareSpotifyLink: .spotifyLogo
        case .shareYouTubeMusicLink: .youtubeMusicLogo
        case .shareCover: .coverShareIcon
        case .saveCover: .saveCoverIcon
        }
    }
    
    var title: String {
        switch self {
        case .shareAppleMusicLink: "Apple Music"
        case .shareSpotifyLink: "Spotify"
        case .shareYouTubeMusicLink: "YouTube Music"
        case .shareCover: "Share cover"
        case .saveCover: "Save cover"
        }
    }
}
