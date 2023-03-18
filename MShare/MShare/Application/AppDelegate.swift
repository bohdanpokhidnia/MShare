//
//  AppDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        print("[dev] model: \(UIDevice.phone.rawValue)")
        
        return true
    }

}

