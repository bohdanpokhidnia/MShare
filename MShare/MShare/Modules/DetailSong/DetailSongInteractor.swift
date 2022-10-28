//
//  DetailSongInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongInteractorInputProtocol {
    var presenter: DetailSongInteractorOutputProtocol? { get set }
    
    func requestMedia()
    func copyImageToBuffer(_ image: UIImage?)
    func saveToDatabase()
}

protocol DetailSongInteractorOutputProtocol: AnyObject {
    func didLoadDetailMedia(_ detailMedia: DetailSongEntity)
}

final class DetailSongInteractor {
    weak var presenter: DetailSongInteractorOutputProtocol?
    
    private let mediaResponse: MediaResponse
    private let cover: UIImage
    private let databaseManager: DatabaseManagerProtocol = DatabaseManager()
    
    init(mediaResponse: MediaResponse, cover: UIImage) {
        self.mediaResponse = mediaResponse
        self.cover = cover
    }
}

// MARK: - DetailSongInteractorInputProtocol

extension DetailSongInteractor: DetailSongInteractorInputProtocol {
    
    func requestMedia() {
        switch mediaResponse.mediaType {
        case .song:
            guard let song = mediaResponse.song else { return }
            let detailSong = DetailSongEntity(songName: song.songName,
                                              artistName: song.artistName,
                                              image: cover,
                                              sourceURL: song.songUrl,
                                              services: mediaResponse.services)
            
            
            presenter?.didLoadDetailMedia(detailSong)
            
            
        case .album:
            guard let album = mediaResponse.album else { return }
            let detailAlbum = DetailSongEntity(songName: album.albumName,
                                               artistName: album.artistName,
                                               image: cover,
                                               sourceURL: album.albumUrl,
                                               services: mediaResponse.services)
            
            presenter?.didLoadDetailMedia(detailAlbum)
        }
    }
    
    func copyImageToBuffer(_ image: UIImage?) {
        UIPasteboard.general.image = image
    }
    
    func saveToDatabase() {
        guard let coverData = cover.pngData() else {
            print("[dev] error get png data from cover")
            return
        }
        
        let mediaModel = MediaModel(mediaResponse: mediaResponse, coverData: coverData)
        
        databaseManager.save(mediaModel) { (error) in
            if let error {
                print("[dev] error: \(error.localizedDescription)")
            } else {
                print("[dev] media success saved")
            }
        }
    }
    
}
