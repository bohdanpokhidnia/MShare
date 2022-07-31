//
//  ServiceEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

struct ServiceEntity: Decodable {
    let name: String
    let type: String
}

extension ServiceEntity {
    
    static let mock = ServiceEntity(name: "Apple Music", type: "")
    static let mock1 = ServiceEntity(name: "Spotify", type: "")
    
}
