//
//  NetworkErrorResponse.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.09.2022.
//

import Foundation

struct NetworkErrorResponse: Decodable {
    let statusCode: Int
    let statusDescription: String
    let message: String
}
