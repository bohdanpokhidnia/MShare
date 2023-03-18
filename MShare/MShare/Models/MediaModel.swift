//
//  MediaModel.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation
import RealmSwift

@objcMembers
final class MediaModel: Object {
    
    dynamic var sourceId: String = ""
    dynamic var url: String = ""
    dynamic var name: String = ""
    dynamic var artistName: String = ""
    dynamic var albumName: String = ""
    dynamic var coverImageUrl: String = ""
    dynamic var serviceType: String = ""
    dynamic var mediaType: String = ""
    dynamic var coverData: Data = Data()
    
    var services = List<ServiceModel>()
    
    // MARK: - Override methods
    
    override class func primaryKey() -> String? {
        return #keyPath(sourceId)
    }
    
    // MARK: - Initializers
    
    convenience init(mediaResponse: MediaResponse, coverData: Data) {
        self.init()
        
        if let song = mediaResponse.song {
            sourceId = song.songSourceId
            url = song.songUrl
            name = song.songName
            artistName = song.artistName
            albumName = song.albumName
            coverImageUrl = song.coverImageUrl
            serviceType = song.serviceType
            mediaType = MediaType.song.rawValue
        } else if let album = mediaResponse.album {
            sourceId = album.albumSourceId
            url = album.albumUrl
            name = album.albumName
            artistName = album.artistName
            albumName = album.albumName
            coverImageUrl = album.coverImageUrl
            serviceType = album.serviceType
            mediaType = MediaType.album.rawValue
        }
        
        self.coverData = coverData
        services.append(objectsIn: mediaResponse.services.map { ServiceModel(mediaService: $0) })
    }
    
}
