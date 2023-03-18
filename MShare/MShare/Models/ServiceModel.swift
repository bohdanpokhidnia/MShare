//
//  ServiceModel.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation
import RealmSwift

@objcMembers
final class ServiceModel: Object {
    
    dynamic var id: UUID = UUID()
    dynamic var name: String = ""
    dynamic var type: String = ""
    dynamic var isAvailable: Bool = false
    
    // MARK: - Override methods
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
    
    // MARK: - Initializers
    
    convenience init(mediaService: MediaService) {
        self.init()
        
        id = UUID()
        name = mediaService.name
        type = mediaService.type
        isAvailable = mediaService.isAvailable
    }
    
}
