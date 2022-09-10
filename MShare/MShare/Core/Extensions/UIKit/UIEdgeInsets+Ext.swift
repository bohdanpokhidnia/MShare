//
//  UIEdgeInsets+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

extension UIEdgeInsets {
    
    init(aTop: CGFloat = 0, aLeft: CGFloat = 0, aBottom: CGFloat = 0, aRight: CGFloat = 0) {
        self.init(top: aTop, left: aLeft, bottom: aBottom, right: aRight)
    }
    
    init(all: CGFloat = 0) {
        self.init()
        if all != 0 {
            (top, bottom, left, right) = (all, all, all, all)
        }
    }
    
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init()
        (top, bottom, left, right) = (vertical, vertical, horizontal, horizontal)
    }
    
    init(vertical: CGFloat = 0) {
        self.init(vertical: vertical, horizontal: 0)
    }
    
    init(horizontal: CGFloat = 0) {
        self.init(vertical: 0, horizontal: horizontal)
    }
    
}
