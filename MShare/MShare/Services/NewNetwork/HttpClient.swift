//
//  HttpClient.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 09.03.2023.
//

import Foundation

protocol HttpClient {
    var scheme: String { get }
    var host: String { get }
    var subPath: String { get }
    
    func request<T: Decodable>(endpoint: Endpoint, response: T.Type) async -> Result<T, NetworkError>
    func request(urlString: String) async -> (Data?, NetworkError?)
}
