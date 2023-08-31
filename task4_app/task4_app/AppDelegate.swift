//
//  AppDelegate.swift
//  task4_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
}
