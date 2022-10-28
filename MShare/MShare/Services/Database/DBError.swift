//
//  DBError.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.10.2022.
//

import Foundation

enum DBError: Error {
    case isInvalidate, other(Error)

    var localizedDescription: String {
        switch self {
        case .isInvalidate:
            return "Object is invalidate"

        case .other(let error):
            return error.localizedDescription
        }
    }
}
