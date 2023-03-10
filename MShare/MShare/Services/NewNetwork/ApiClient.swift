//
//  ApiClient.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 09.03.2023.
//

import Foundation

final class ApiClient: HttpClient {
    
    var scheme: String { "http" }
    var host: String { "95.179.252.251" }
    var subPath: String { "/api/v1/" }
    
    func request<T: Decodable>(endpoint: Endpoint, response: T.Type) async -> Result<T, NetworkError> {
        
        guard let url = makeUrl(endpoint: endpoint) else {
            return .failure(.invalidUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            do {
                let httpBody = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = httpBody
            } catch {
                return .failure(.invaildBody)
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
         
            logRequest(urlRequest: request, response: response, data: data)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.message("No response"))
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? endpoint.decoder.decode(T.self, from: data) else { return .failure(.failedDecode) }
                return .success(decodedResponse)
                
            case 401:
                return .failure(.unauthorized)
                
            default:
                do {
                    let netwrokErrorResposne = try await decodeErrorResponse(from: data, withDecoder: endpoint.decoder)
                    return .failure(.networkError(netwrokErrorResposne))
                } catch {
                    return .failure(.error(error))
                }
            }
        } catch {
            return .failure(.error(error))
        }
    }
    
    func request(urlString: String) async -> (Data?, NetworkError?) {
        guard let url = URL(string: urlString) else { return (nil, .invalidUrl) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return (data, nil)
        } catch {
            return (nil, .error(error))
        }
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
        
        if let httpBody = urlRequest?.httpBody,
           let stringBody = String(data: httpBody, encoding: .utf8) {
            body = stringBody
        } else {
            body = "NONE"
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let response: String
        
        if let data,
           let stringResponse = String(data: data, encoding: .utf8) {
            response = stringResponse
        } else {
            response = "NONE"
        }
        
        let log = "ℹ️ [API] Request: \(methodWithUrl)\nHeaders: \(headers)\nBody: \(body)\nStatus code: \(statusCode)\nResponse: \(response)"
        print(log)
    }
    
}
