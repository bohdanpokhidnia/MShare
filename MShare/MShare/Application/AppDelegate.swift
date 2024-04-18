//
//  AppDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit
import TipKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 17.0, *) {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
        
        return true
    }
}
