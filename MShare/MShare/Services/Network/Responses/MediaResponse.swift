//
//  MediaResponse.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import Foundation

enum MediaType: String, Decodable {
    case song = "Song"
    case album = "Album"
}

struct MediaResponse: Decodable {
    let mediaType: MediaType
    let song: Song?
    let album: Album?
    let services: [MediaService]
    
    var coverUrlString: String {
        switch mediaType {
        case .song:
            return song!.coverImageUrl
            
        case .album:
            return album!.coverImageUrl
        }
    }
}

extension MediaResponse {
    static var mock = MediaResponse(
        mediaType: .song,
        song: .mock,
        album: nil,
        services: [.mock]
    )
}

struct Song: Decodable {
    let songSourceId: String
    let songUrl: String
    let songName: String
    let artistName: String
    let albumName: String
    let coverImageUrl: String
    let serviceType: String
}

extension Song {
    static var mock = Song(
        songSourceId: "",
        songUrl: "mock url",
        songName: "mock song name",
        artistName: "mock artist name",
        albumName: "mock album name",
        coverImageUrl: "https://is1-ssl.mzstatic.com//image//thumb//Music125//v4//f9//33//f9//f933f91d-e4b8-f1fb-8534-11f537ae8c84//Lums_Cleopatra_cvr.jpg//640x640bb.jpg",
        serviceType: "mock service type"
    )
}

struct Album: Decodable {
    let albumSourceId: String
    let albumUrl: String
    let albumName: String
    let artistName: String
    let coverImageUrl: String
    let serviceType: String
}

struct MediaService: Decodable {
    let name: String
    let type: String
    let isAvailable: Bool
}

extension MediaService {
    static var mock = MediaService(name: "AppleMusic", type: "Apple Music", isAvailable: true)
}
