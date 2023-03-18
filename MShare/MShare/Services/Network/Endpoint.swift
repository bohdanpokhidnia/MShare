//
//  Endpoint.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 09.03.2023.
//

import Foundation
import StoreKit

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    case put = "PUT"
}

protocol Endpoint {
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: String]? { get }
    var decoder: JSONDecoder { get }
}

class BaseEndpoint: Endpoint {
    
    var path: String { "" }
    var method: RequestMethod { .get }
    
    var header: [String : String]? {
        let userLocale: String?
        let regionCode: String? = SKPaymentQueue.default().storefront?.countryCode
        
        if #available(iOS 16.0, *){
            userLocale = Locale.current.language.region?.identifier
        } else {
            userLocale = Locale.current.regionCode
        }
        
        return [
            "mshare-user-locate": userLocale ?? "US",
            "mshare-store-region": regionCode ?? "USA",
            "mshare-os-name": UIDevice.current.systemName,
            "mshare-os-version": UIDevice.current.systemVersion,
            "mshare-device-id": UIDevice.current.identifierForVendor!.uuidString
        ]
    }
    var queryItems: [URLQueryItem]? { nil }
    var body: [String : String]? { nil }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
}

class EndPointBaseItem<T: Encodable>: BaseEndpoint {
    
    private let item: T?
    
    init(_ item: T? = nil, _ closure: (() -> (T?))? = nil) {
        self.item = item ?? closure?()
    }
    
    override var queryItems: [URLQueryItem]? {
        guard let item else { return nil }
        
        do {
            let data = try JSONEncoder().encode(item)
            let items = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: String?]
            let queryItems = items?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            return queryItems
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

class GetEndpoint: BaseEndpoint {
    override var method: RequestMethod { .get }
}

class GetEndpointItem<T: Encodable>: EndPointBaseItem<T> {
    override var method: RequestMethod { .get }
}

class PostEndpoint: BaseEndpoint {
    override var method: RequestMethod { .post }
}
