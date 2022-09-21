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
    
    var title: String {
        switch self {
        case .networkError(let networkError):
            return networkError.statusDescription
            
        case .message(_), .error(_):
            return "Warning"
        }
    }
    
    var localizedDescription: String {
        switch self {
            
        case .networkError(let networkError):
            return networkError.message
            
        case .message(let message):
            return message ?? ""
            
        case .error(let error):
            return error.localizedDescription
        }
    }
}
