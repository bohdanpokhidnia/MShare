//
//  ServiceEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

struct ServiceEntity: Decodable {
    let name: String
    let songs: [DetailSongEntity]
}

extension ServiceEntity {
    
    static let mock = ServiceEntity(name: "Apple Music", songs: [.mock, .mock1])
    
}
