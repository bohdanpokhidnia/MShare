//
//  DetailSongEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import Foundation

struct DetailSongEntity: Decodable {
    let songName: String
    let artistName: String
    let coverURL: String
    let sourceURL: String
}

extension DetailSongEntity {
    
    static let mock = DetailSongEntity(songName: "Любила - Single",
                                       artistName: "Саша Чемеров and Boombox",
                                       coverURL: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/e0/55/0d/e0550d66-3ff5-c6a5-bce9-e8b6e050b3f2/cover.jpg/1000x1000bb-60.jpg",
                                       sourceURL: "https://music.apple.com/ua/album/любила/1569008787?i=1569008792")
    
    static let mock1 = DetailSongEntity(songName: "Любила",
                                        artistName: "Саша Чемеров",
                                        coverURL: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/e0/55/0d/e0550d66-3ff5-c6a5-bce9-e8b6e050b3f2/cover.jpg/1000x1000bb-60.jpg",
                                        sourceURL: "https://music.apple.com/ua/album/любила/1569008787?i=1569008792")
    
}
