//
//  SongListPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import Foundation

protocol SongListPresenterProtocol: AnyObject {
    var view: SongListViewProtocol? { get set }
    var interactor: SongListInteractorIntputProtocol? { get set }
    var router: SongListRouterProtocol? { get set }
    
    func viewDidLoad()
    func numberOfRows() -> Int
    func itemForRow(at indexPath: IndexPath) -> MediaItem
}

final class SongListPresenter {
    var view: SongListViewProtocol?
    var interactor: SongListInteractorIntputProtocol?
    var router: SongListRouterProtocol?
    
    private var songs = [MediaItem]()
}

// MARK: - SongListPresenterProtocol

extension SongListPresenter: SongListPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.loadSongList()
    }
    
    func numberOfRows() -> Int {
        return songs.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> MediaItem {
        let song = songs[indexPath.row]
        return song
    }
    
}

// MARK: - SongListInteractorOutputProtocol

extension SongListPresenter: SongListInteractorOutputProtocol {
    
    func didLoadSongList(_ songList: [SongListEntity]) {
        songs.removeAll()
        songs = songList.map { .init(tiile: $0.songName,
                                     subtitle: $0.artistName,
                                     positionNumber: String($0.positionNumber),
                                     displayShareButton: true) }
        
        view?.reloadData()
    }
    
}
