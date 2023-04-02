//
//  MakeCoverInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import UIKit

protocol MakeCoverInteractorIntputProtocol {
    var presenter: MakeCoverInteractorOutputProtocol? { get set }
    
    func requestData()
}

protocol MakeCoverInteractorOutputProtocol: AnyObject {
    func didLoadData(entity: DetailSongEntity)
}

final class MakeCoverInteractor {
    
    weak var presenter: MakeCoverInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(mediaResponse: MediaResponse, cover: UIImage?) {
        self.mediaResponse = mediaResponse
        self.cover = cover
    }
    
    // MARK: - Private
    
    private let mediaResponse: MediaResponse
    private let cover: UIImage?
    
}

// MARK: - MakeCoverInteractorInputProtocol

extension MakeCoverInteractor: MakeCoverInteractorIntputProtocol {
    
    func requestData() {
        let entity: DetailSongEntity
        
        switch mediaResponse.mediaType {
        case .song:
            guard let song = mediaResponse.song else { return }
            entity = .init(
                songName: song.songName,
                artistName: song.artistName,
                image: cover,
                sourceURL: song.songUrl,
                services: []
            )
            
        case .album:
            guard let album = mediaResponse.song else { return }
            entity = .init(
                songName: album.albumName,
                artistName: album.artistName,
                image: cover,
                sourceURL: album.songUrl,
                services: []
            )
        }
        
        presenter?.didLoadData(entity: entity)
    }
    
}
