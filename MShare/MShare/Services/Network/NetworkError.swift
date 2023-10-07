//
//  NetworkError.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import Foundation

enum NetworkError: Error {
    case networkError(NetworkErrorResponse)
    case message(String?)
    case error(Error)
    case invalidUrl
    case invaildBody
    case failedDecode
    case unauthorized
    
    var title: String {
        switch self {
        case .networkError(let networkError):
            return networkError.title
            
        case .message(_), .error(_), .invalidUrl, .invaildBody, .failedDecode, .unauthorized:
            return "Warning"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .networkError(let networkError):
            return "Status code: \(networkError.status), \(networkError.title)"
            
        case .message(let message):
            return message ?? ""
            
        case .error(let error):
            return error.localizedDescription
            
        case .invalidUrl:
            return "Ivalid URL"
        
        case .invaildBody:
            return "Invalid Body"
            
        case .failedDecode:
            return "Failed decode"
            
        case .unauthorized:
            return "Unauthorized"
        }
    }
}
