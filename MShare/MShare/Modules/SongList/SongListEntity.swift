//
//  SongListEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import Foundation

struct SongListEntity: Decodable {
    let positionNumber: Int
    let songName: String
    let artistName: String
    let sourceLink: String
    let coverURL: String
}

extension SongListEntity {
    
    static let mock = SongListEntity(positionNumber: 1,
                                     songName: "Любила - Single",
                                     artistName: "Саша Чемеров",
                                     sourceLink: "https://music.apple.com/ua/album/любила/1569008787?i=1569008792",
                                     coverURL: "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/e0/55/0d/e0550d66-3ff5-c6a5-bce9-e8b6e050b3f2/cover.jpg/1000x1000bb-60.jpg")
    
}
