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

struct Song: Decodable {
    let songSourceId: String
    let songUrl: String
    let songName: String
    let artistName: String
    let albumName: String
    let coverImageUrl: String
    let serviceType: String
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
