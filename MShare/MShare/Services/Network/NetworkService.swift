//
//  NetworkService.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import UIKit

protocol NetworkServiceProtocol {
    var apiBaseURL: URL { get }
    var baseHttpHeaders: [String: String] { get }
    
    func request<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping ((_ response: T?, NetworkError?) -> Void))
}

final class NetworkService: NetworkServiceProtocol {
    
    var apiBaseURL: URL { URL(string: "http://95.179.252.251")! }
    
    var baseHttpHeaders: [String : String] {
        let regionCode = Locale.current.regionCode ?? "US"
        
        return [
            "mshare-os-name": "iOS",
            "mshare-os-version": UIDevice.current.systemVersion,
            "mshare-device-id": UIDevice.current.identifierForVendor!.uuidString,
            "mshare-store-region": regionCode
        ]
    }
    
    func request<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping ((T?, NetworkError?) -> Void)) {
        let requestBilder = endpoint.requestBuilder.httpHeaders(headers: baseHttpHeaders)
        
        guard let urlRequest = requestBilder.makeRequest(baseURL: apiBaseURL) else {
            completion(nil, .message("bad request"))
            return
        }
        
        let jsonDecoder = endpoint.decoder
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                completion(nil, .error(error!))
                return
            }
            
            guard let data else {
                completion(nil, .message("without data"))
                return
            }
            
            do {
                let response = try jsonDecoder.decode(T.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, .error(error))
            }
        }.resume()
    }
    
}
