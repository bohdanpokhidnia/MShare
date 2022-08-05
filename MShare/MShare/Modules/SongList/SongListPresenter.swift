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
    func shareSong(at indexPath: IndexPath)
}

final class SongListPresenter {
    var view: SongListViewProtocol?
    var interactor: SongListInteractorIntputProtocol?
    var router: SongListRouterProtocol?
    
    private var songList = [MediaItem]()
}

// MARK: - SongListPresenterProtocol

extension SongListPresenter: SongListPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.loadSongList()
    }
    
    func numberOfRows() -> Int {
        return songList.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> MediaItem {
        let song = songList[indexPath.row]
        return song
    }
    
    func shareSong(at indexPath: IndexPath) {
        guard let shareActivityViewController = interactor?.makeShareView(at: indexPath),
              let view = view
        else { return }
        
        router?.present(from: view, shareActivityViewController)
    }
    
}

// MARK: - SongListInteractorOutputProtocol

extension SongListPresenter: SongListInteractorOutputProtocol {
    
    func didLoadSongList(_ songList: [SongListEntity]) {
        self.songList.removeAll()
        self.songList = songList.map { .init(tiile: $0.songName,
                                             subtitle: $0.artistName,
                                             imageURL: $0.coverURL,
                                             displayShareButton: true) }
        
        view?.reloadData()
    }
    
}
