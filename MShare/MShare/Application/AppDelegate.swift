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
    
    private lazy var userManager = UserManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        print("[dev] model: \(UIDevice.phone.rawValue)")
        
        DependencyManager {
            Module { self.userManager as UserManagerProtocol }
        }.build()
        
        return true
    }

}

