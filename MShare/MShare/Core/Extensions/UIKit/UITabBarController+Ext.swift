//
//  UITabBarController+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.04.2023.
//

import UIKit

extension UITabBarController {
    func setTabBar(hidden: Bool, animated: Bool, completion: (() -> Void)? = nil ) {
        if (tabBar.isHidden == hidden) {
            completion?()
        }

        if !hidden {
            tabBar.isHidden = false
        }

        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (hidden ? 0 : height)
        let duration = (animated ? 0.25 : 0.0)
        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame = frame
        }) { _ in
            self.tabBar.isHidden = hidden
            completion?()
        }
    }
}
