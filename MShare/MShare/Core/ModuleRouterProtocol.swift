//
//  ModuleRouterProtocol.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol ModuleRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func createModule() -> UIViewController
}
