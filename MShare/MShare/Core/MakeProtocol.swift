//
//  MakeProtocol.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol MakeProtocol {}

extension MakeProtocol {
    
    @discardableResult
    func make(_ completion: (Self) -> Void) -> Self {
        completion(self)
        return self
    }
    
}

// MARK: - MakeProtocol

extension UIView: MakeProtocol {}

extension UISearchController: MakeProtocol {}
