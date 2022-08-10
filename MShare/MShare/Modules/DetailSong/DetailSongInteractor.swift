//
//  DetailSongInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import Foundation

protocol DetailSongInteractorIntputProtocol {
    var presenter: DetailSongInteractorOutputProtocol? { get set }
    
    func requestSong()
}

protocol DetailSongInteractorOutputProtocol: AnyObject {
    func didLoadSong(_ song: DetailSongEntity)
}

final class DetailSongInteractor {
    weak var presenter: DetailSongInteractorOutputProtocol?
    
    private var song: DetailSongEntity
    
    init(_ song: DetailSongEntity) {
        self.song = song
    }
}

// MARK: - DetailSongInteractorInputProtocol

extension DetailSongInteractor: DetailSongInteractorIntputProtocol {
    
    func requestSong() {
        presenter?.didLoadSong(song)
    }
    
}
