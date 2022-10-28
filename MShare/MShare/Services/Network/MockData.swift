//
//  MockData.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation

extension NetworkService {
    
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
                                                     song: .init(songSourceId: "1556035501",
                                                                 songUrl: "https://music.apple.com/ua/album/lividi-sui-gomiti/1556035498?i=1556035501&uo=4",
                                                                 songName: "LIVIDI SUI GOMITI",
                                                                 artistName: "Måneskin",
                                                                 albumName: "Teatro d'Ira - Vol. I",
                                                                 coverImageUrl: "https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/4b/1a/72/4b1a7220-bee2-8664-7153-adffa8d3df1e/886449063819.jpg/640x640bb.jpg",
                                                                 serviceType: "AppleMusic"),
                                                     album: nil,
                                                     services: [.init(name: "Apple Music", type: "AppleMusic", isAvailable: true),
                                                                .init(name: "Spotify", type: "Spotify", isAvailable: false),
                                                                .init(name: "Youtube Music", type: "YoutubeMusic", isAvailable: false)])
    }
    
}
