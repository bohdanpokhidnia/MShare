//
//  Endpoint.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import Foundation

protocol EndpointProtocol {
    var requestBuilder: RequestBuilder { get set }
    var decoder: JSONDecoder { get }
}
