//
//  ShareMediaResponse.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 26.11.2022.
//

import Foundation

struct ShareMediaResponse: Decodable {
    let isEmpty: Bool
    let count: Int
    let items: [ShareMediaItem]
}

struct ShareMediaItem: Decodable {
    let songSourceId: String
    let songUrl: String
    let artistName: String
    let albumName: String
    let coverImageUrl: String
    let serviceType: String
}
