//
//  DatabaseManager+Media.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation

// MARK: - DatabaseManagerMediaProtocol

extension DatabaseManager: DatabaseManagerMediaProtocol {
    
    func getMediaModels(by mediaType: MediaType) -> [MediaModel] {
        let mediaModels = getObjects(MediaModel.self, filter: "mediaType = '\(mediaType.rawValue)'")
        return mediaModels
    }
    
}
