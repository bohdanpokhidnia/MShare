//
//  NetworkService.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import UIKit
import StoreKit

protocol NetworkServiceProtocol {
    var apiBaseURL: URL { get }
    var baseHttpHeaders: [String: String] { get }
    
    func request<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping ((_ response: T?, NetworkError?) -> Void))
    func request(urlString: String, completion: @escaping (Data?, NetworkError?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    var apiBaseURL: URL { URL(string: "http://95.179.252.251")! }
    
    var baseHttpHeaders: [String : String] {
        let userLocate: String

        if #available(iOS 16.0, *) {
            userLocate = Locale.current.language.region?.identifier ?? "US"
        } else {
            userLocate = Locale.current.regionCode ?? "US"
        }

        let regionCode = SKPaymentQueue.default().storefront?.countryCode ?? "USA"

        return [
            "mshare-os-name": UIDevice.current.systemName,
            "mshare-os-version": UIDevice.current.systemVersion,
            "mshare-device-id": UIDevice.current.identifierForVendor!.uuidString,
            "mshare-store-region": regionCode,
            "mshare-user-locate": userLocate
        ]
    }
    
    func request<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping ((T?, NetworkError?) -> Void)) {
        let requestBilder = endpoint.requestBuilder.httpHeaders(headers: baseHttpHeaders)
        
        guard let urlRequest = requestBilder.makeRequest(baseURL: apiBaseURL) else {
            completion(nil, .message("bad request"))
            return
        }
        
        let jsonDecoder = endpoint.decoder
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            self?.logRequest(urlRequest: urlRequest, response: response, data: data, error: error)
            
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
                self?.decodeErrorResponse(from: data, with: endpoint.decoder) { (result) in
                    switch result {
                    case .success(let networkErrorResponse):
                        completion(nil, .networkError(networkErrorResponse))
                        
                    case .failure(let error):
                        completion(nil, .error(error))
                    }
                }
            }
        }.resume()
    }
    
    func request(urlString: String, completion: @escaping (Data?, NetworkError?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, .message("bad url"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(nil, .error(error!))
                return
            }
            
            guard let data else {
                completion(nil, .message("without data"))
                return
            }
            
            completion(data, nil)
        }.resume()
    }
    
}

// MARK: - Private Methods

private extension NetworkService {
    
    func decodeErrorResponse(from data: Data, with decoder: JSONDecoder, completion: ((Result<NetworkErrorResponse, Error>) -> Void)) {
        do {
            let erroResponse = try decoder.decode(NetworkErrorResponse.self, from: data)
            completion(.success(erroResponse))
        } catch {
            completion(.failure(error))
        }
    }
    
    func logRequest(urlRequest: URLRequest?, response: URLResponse?, data: Data?, error: Error?) {
        let methodWithUrl = "[\(urlRequest?.httpMethod ?? "Unknown method")] \(urlRequest?.url?.absoluteString ?? "Unknown url")"
        let headers = (urlRequest?.allHTTPHeaderFields ?? ["": ""]).map { "\($0.key): \($0.value)" }
        let body: String
        
        if let httpBody = urlRequest?.httpBody,
           let stringBody = String(data: httpBody, encoding: .utf8) {
            body = stringBody
        } else {
            body = "NONE"
        }
        
        let error = error?.localizedDescription ?? "NONE"
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let response: String
        
        if let data,
           let stringResponse = String(data: data, encoding: .utf8) {
            response = stringResponse
        } else {
            response = "NONE"
        }
        
        let log = "ℹ️ [API] Request: \(methodWithUrl)\nHeaders: \(headers)\nBody: \(body)\nError: \(error)\nStatus code: \(statusCode)\nResponse: \(response)"
        print(log)
    }
    
}
