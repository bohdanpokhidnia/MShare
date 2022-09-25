//
//  DetailSongEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

struct DetailSongEntity {
    let songName: String
    let artistName: String
    let image: UIImage?
    let sourceURL: String
}

extension DetailSongEntity {
    
    static let mock = DetailSongEntity(songName: "Любила - Single",
                                       artistName: "Саша Чемеров and Boombox",
                                       image: nil,
                                       sourceURL: "https://music.apple.com/ua/album/любила/1569008787?i=1569008792")
    
    static let mock1 = DetailSongEntity(songName: "Любила",
                                        artistName: "Саша Чемеров",
                                        image: nil,
                                        sourceURL: "https://music.apple.com/ua/album/любила/1569008787?i=1569008792")
    
}
