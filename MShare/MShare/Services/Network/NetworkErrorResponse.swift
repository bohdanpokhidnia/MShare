//
//  NetworkErrorResponse.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.09.2022.
//

import Foundation

struct NetworkErrorResponse: Decodable {
    let type: String
    let title: String
    let status: Int
    let errors: [String: [String]]
}
