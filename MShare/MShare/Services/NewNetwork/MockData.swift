//
//  MockData.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation

struct MockData {
    static let mockDetailSongEntity = DetailSongEntity(songName: "Любила - Single",
                                                       artistName: "Саша Чемеров and Boombox",
                                                       image: nil,
                                                       sourceURL: "https://music.apple.com/ua/album/любила/1569008787?i=1569008792",
                                                       services: [
                                                        .init(name: "Apple Music", type: "AppleMusic", isAvailable: true),
                                                        .init(name: "Spotify", type: "Spotify", isAvailable: true),
                                                        .init(name: "Youtube Music", type: "YoutubeMusic", isAvailable: false)
                                                       ])
    
    static let songMediaResponse = MediaResponse(mediaType: .song,
                                                 song: .init(songSourceId: "1479105644",
                                                             songUrl: "https://music.apple.com/ua/album/%D1%82%D0%B2%D1%96%D0%B9-%D0%BD%D0%B0-100/1479103809?i=1479105644",
                                                             songName: "Твій на 100%",
//                                                                 songName: "Заведу Кота (Наживо)",
                                                             artistName: "Boombox",
                                                             albumName: "Таємний код. Рубікон, Частина 1",
                                                             coverImageUrl: "https://is3-ssl.mzstatic.com/image/thumb/Music113/v4/3f/83/79/3f8379c8-f8b1-f77e-6dec-6cfcd6d2e740/cover.jpg/640x640bb.jpg",
                                                             serviceType: "AppleMusic"),
                                                 album: nil,
                                                 services: [
                                                    .init(name: "Spotify", type: "Spotify", isAvailable: true),
                                                    .init(name: "Apple Music", type: "AppleMusic", isAvailable: true),
                                                            .init(name: "Youtube Music", type: "YoutubeMusic", isAvailable: false)])
}
