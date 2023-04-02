//
//  Factory.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import UIKit

protocol FactoryProtocol {
    func mapDetailEntity(from mediaResponse: MediaResponse, withImage image: UIImage?) -> DetailSongEntity?
}

final class Factory: FactoryProtocol {
    
    func mapDetailEntity(from mediaResponse: MediaResponse, withImage image: UIImage?) -> DetailSongEntity? {
        switch mediaResponse.mediaType {
        case .song:
            guard let song = mediaResponse.song else { return nil }
            return .init(
                songName: song.songName,
                artistName: song.artistName,
                image: image,
                sourceURL: song.songUrl,
                services: mediaResponse.services
            )
            
        case .album:
            guard let album = mediaResponse.album else { return nil }
            return .init(
                songName: album.albumName,
                artistName: album.artistName,
                image: image,
                sourceURL: album.albumUrl,
                services: mediaResponse.services
            )
        }
    }
    
}
