//
//  ApiClient.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 09.03.2023.
//

import Foundation

final class ApiClient: HttpClient {
    var scheme: String { "https" }
    var host: String { "mshare-api.site" }
    var subPath: String { "/api/v1/" }
    
    func request<T: Decodable>(endpoint: Endpoint, response: T.Type) async throws -> T {
        guard let url = makeUrl(endpoint: endpoint) else {
            throw NetworkError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let body = endpoint.body {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = httpBody
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.message("Without response")
        }
        
        logRequest(urlRequest: request, response: response, data: data)

        switch response.statusCode {
        case 200...299:
            let decodeResponse = try endpoint.decoder.decode(T.self, from: data)
            return decodeResponse

        case 401:
            throw NetworkError.unauthorized

        default:
            let errorResponse = try await decodeErrorResponse(from: data, withDecoder: endpoint.decoder)
            throw NetworkError.networkError(errorResponse)
        }
    }
    
    func request(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

// MARK: - Private Methods

private extension ApiClient {
    func makeUrl(endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = [subPath, endpoint.path].joined()
        components.queryItems = endpoint.queryItems
        return components.url
    }
    
    func decodeErrorResponse(from data: Data, withDecoder decoder: JSONDecoder) async throws -> NetworkErrorResponse {
        let networkErrorResponse = try decoder.decode(NetworkErrorResponse.self, from: data)
        return networkErrorResponse
    }
    
    func logRequest(urlRequest: URLRequest?, response: URLResponse?, data: Data?) {
        let methodWithUrl = "[\(urlRequest?.httpMethod ?? "Unknown method")] \(urlRequest?.url?.absoluteString ?? "Unknown url")"
        let headers = (urlRequest?.allHTTPHeaderFields ?? ["": ""]).map { "\($0.key): \($0.value)" }
        let body: String
        
        if let bodyData = urlRequest?.httpBody {
            body = prettyString(from: bodyData) ?? "NONE"
        } else {
            body = "NONE"
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        var response: String
        
        if let data {
            response = prettyString(from: data) ?? "NONE"
        } else {
            response = "NONE"
        }
        
        let logData = [
            "Request: \(methodWithUrl)",
            "Headers: \(headers)",
            "Body:\n\(body)",
            "Status code: \(statusCode)",
            "Response:\n\(response)"
        ]
        .joined(separator: "\n")
        
        dprint(logData)
    }
    
    func prettyString(from data: Data) -> String? {
        do {
            let dataObject = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataObject, options: .prettyPrinted)
            let string = String(data: prettyData, encoding: .utf8)
            return string
        } catch {
            return nil
        }
    }
}
