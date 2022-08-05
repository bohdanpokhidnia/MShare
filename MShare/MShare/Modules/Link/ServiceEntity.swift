//
//  ServiceEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

enum ServiceLogo: String {
    case appleMusic = "appleMusic"
    case spotify = "spotify"
}

struct ServiceEntity: Decodable {
    let name: String
    let type: String
    
    var imageLogo: UIImage? {
        switch ServiceLogo(rawValue: type) {
        case .appleMusic:
            return UIImage(named: "appleMusicLogo")
            
        case .spotify:
            return UIImage(named: "spotifyLogo")
            
        case .none:
            return nil
        }
    }
}

extension ServiceEntity {
    
    static let mock = ServiceEntity(name: "Apple Music", type: "appleMusic")
    static let mock1 = ServiceEntity(name: "Spotify", type: "spotify")
    
}
