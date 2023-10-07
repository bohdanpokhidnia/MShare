//
//  NetworkErrorHandling.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 07.10.2023.
//

import Foundation

protocol NetworkErrorHandling {
    func handleNetworkError(error: BaseError)
}
