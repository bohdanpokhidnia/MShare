//
//  UIApplication.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.01.2023.
//

import UIKit

extension UIApplication {
    
    static var windowScene: UIWindowScene { shared.connectedScenes.first as! UIWindowScene }
    
}
