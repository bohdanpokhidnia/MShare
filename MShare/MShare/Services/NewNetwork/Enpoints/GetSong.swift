//
//  GetSong.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 09.03.2023.
//

import Foundation

final class GetSong: GetEndpointItem<GetSong.QueryItems> {
    
    override var path: String { "song" }
    
    init(url: String) {
        super.init(.init(url: url))
    }
    
    struct QueryItems: Encodable {
        let url: String
    }
    
}
