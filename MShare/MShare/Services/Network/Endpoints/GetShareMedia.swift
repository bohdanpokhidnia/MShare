//
//  GetShareMedia.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 26.11.2022.
//

import Foundation

final class GetShareMedia: EndpointProtocol {
    
    var requestBuilder: RequestBuilder
    var decoder: JSONDecoder { JSONDecoder() }
    
    init(originService: String, sourceId: String, destinationService: String) {
        requestBuilder = RequestBuilder
            .get(path: "/api/v1/Song/\(originService)/\(sourceId)/for/\(destinationService)")
    }
    
}
