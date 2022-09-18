//
//  NetworkError.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 18.09.2022.
//

import Foundation

enum NetworkError: Error {
    case message(String?)
    case error(Error)
    
    var localizedDescription: String {
        switch self {
            
        case .message(let message):
            return message ?? ""
            
        case .error(let error):
            return error.localizedDescription
        }
    }
}
