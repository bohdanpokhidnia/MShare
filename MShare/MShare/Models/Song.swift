//
//  Song.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import Foundation

struct Song: Decodable {
    let songSourceId: String
    let songUrl: String
    let songName: String
    let artistName: String
    let albumName: String
    let coverImageUrl: String
    let serviceType: String
    let services: [SongService]
}

struct SongService: Decodable {
    let name: String
    let type: String
    let isAvailable: Bool
}
