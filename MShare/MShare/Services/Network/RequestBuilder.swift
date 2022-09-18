//
//  RequestBuilder.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import Foundation

struct RequestBuilder {
    
    static let baseURL = URL(string: "http://95.179.252.251")!
    static let jsonEncoder = JSONEncoder()
    
    var buildURLRequest: (inout URLRequest) -> Void
    var urlComponents: URLComponents
    
    private init(urlComponents: URLComponents) {
        self.urlComponents = urlComponents
        self.buildURLRequest = { _ in }
    }
    
    init(path: String) {
        var components = URLComponents()
        components.path = path
        self.init(urlComponents: components)
    }
    
}

extension RequestBuilder {
    
    func makeRequest(baseURL: URL) -> URLRequest? {
        let finalURL = urlComponents.url(relativeTo: baseURL) ?? baseURL
        
        var urlRequest = URLRequest(url: finalURL)
        buildURLRequest(&urlRequest)
        
        return urlRequest
    }
    
}

extension RequestBuilder {
    
    func modifyURLComponents(_ modifyURLComponents: @escaping (inout URLComponents) -> Void) -> RequestBuilder {
        var copy = self
        modifyURLComponents(&copy.urlComponents)
        
        return copy
    }
    
    func modifyURLRequest(_ modifyURLRequest: @escaping (inout URLRequest) -> Void) -> RequestBuilder {
        var copy = self
        let existing = buildURLRequest
        
        copy.buildURLRequest = { request in
            existing(&request)
            modifyURLRequest(&request)
        }
        
        return copy
    }
    
}

extension RequestBuilder {
    
    func queryItems(_ queryItems: [URLQueryItem]) -> RequestBuilder {
        return modifyURLComponents { (urlComponents) in
            var items = urlComponents.queryItems ?? []
            items.append(contentsOf: queryItems)
            urlComponents.queryItems = items
        }
    }

    func queryItem(name: String, value: String) -> RequestBuilder {
        return queryItems([.init(name: name, value: value)])
    }

}

extension RequestBuilder {
    
    enum HTTPRequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case head = "HEAD"
        case delete = "DELETE"
        case patch = "PATCH"
        case options = "OPTIONS"
        case connect = "CONNECT"
        case trace = "TRACE"
    }

    func httpMethod(_ method: HTTPRequestMethod) -> RequestBuilder {
        modifyURLRequest { $0.httpMethod = method.rawValue }
    }
    
}

extension RequestBuilder {
    
    func httpHeader(name: String, value: String) -> RequestBuilder {
        modifyURLRequest { $0.addValue(value, forHTTPHeaderField: name) }
    }
    
    func httpHeaders(headers: [String: String]) -> RequestBuilder {
        modifyURLRequest { builder in
            headers.forEach {
                builder.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
    }
    
}

extension RequestBuilder {
    
    func httpBody(_ body: Data) -> RequestBuilder {
        modifyURLRequest { $0.httpBody = body }
    }
    
    func httpJSONBody<Content: Encodable>(_ body: Content, encoder: JSONEncoder = RequestBuilder.jsonEncoder) throws -> RequestBuilder {
        let body = try encoder.encode(body)
        return httpBody(body)
    }
    
}

extension RequestBuilder {
    
    // MARK: - Factories
    
    static func get(path: String) -> RequestBuilder {
        return RequestBuilder(path: path)
            .httpMethod(.get)
    }
    
    static func post(path: String) -> RequestBuilder {
        return RequestBuilder(path: path)
            .httpMethod(.post)
    }

    // MARK: - JSON Factories
    
    static func jsonGet(path: String) -> RequestBuilder {
        .get(path: path)
        .httpHeader(name: "Content-Type", value: "application/json")
    }
    
    static func jsonPost(path: String, jsonData: Data) -> RequestBuilder {
        .post(path: path)
        .httpHeader(name: "Content-Type", value: "application/json")
        .httpBody(jsonData)
    }
    
    static func jsonPost<Content: Encodable>(path: String,
                                             jsonObject: Content,
                                             encoder: JSONEncoder = RequestBuilder.jsonEncoder)
    throws -> RequestBuilder {
        try .post(path: path)
            .httpHeader(name: "Content-Type", value: "application/json")
            .httpJSONBody(jsonObject, encoder: encoder)
    }
    
}
