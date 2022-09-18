//
//  GetSong.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import UIKit

final class GetSong: EndpointProtocol {
    
    var requestBuilder: RequestBuilder
    var decoder: JSONDecoder { JSONDecoder() }
    
    init(byUrl urlString: String) {
        requestBuilder = RequestBuilder
            .get(path: "/api/v1/song")
            .queryItem(name: "url", value: urlString)
    }
    
}
