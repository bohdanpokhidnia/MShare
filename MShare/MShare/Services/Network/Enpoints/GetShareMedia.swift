//
//  GetShareMedia.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 09.03.2023.
//

import Foundation

final class GetShareMedia: GetEndpoint {
    
    override var path: String { "song/\(originService)/\(sourceId)/for/\(destinationService)" }
    
    let originService: String
    let sourceId: String
    let destinationService: String
    
    init(originService: String, sourceId: String, destinationService: String) {
        self.originService = originService
        self.sourceId = sourceId
        self.destinationService = destinationService
    }
    
}
