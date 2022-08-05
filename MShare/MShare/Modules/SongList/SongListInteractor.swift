//
//  SongListInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import UIKit

protocol SongListInteractorIntputProtocol {
    var songList: [SongListEntity] { get set }
    var presenter: SongListInteractorOutputProtocol? { get set }
    
    func loadSongList()
    func makeShareView(at indexPath: IndexPath) -> UIActivityViewController
}

protocol SongListInteractorOutputProtocol: AnyObject {
    func didLoadSongList(_ songList: [SongListEntity])
}

final class SongListInteractor {
    var songList: [SongListEntity]
    weak var presenter: SongListInteractorOutputProtocol?
    
    init(songList: [SongListEntity]) {
        self.songList = songList
    }
}

// MARK: - SongListInteractorInputProtocol

extension SongListInteractor: SongListInteractorIntputProtocol {
    
    func loadSongList() {
        presenter?.didLoadSongList(songList)
    }
    
    func makeShareView(at indexPath: IndexPath) -> UIActivityViewController {
        let link = songList[indexPath.row].sourceLink
        
        let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        return activityViewController
    }
    
}
