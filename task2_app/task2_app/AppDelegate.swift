//
//  AppDelegate.swift
//  task2_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
                application.registerForRemoteNotifications()
            } else {
                print("Notification authorization denied")
            }
        }
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          if notification.request.identifier == "alarm" {
              let viewController = self.window?.rootViewController as? UINavigationController
              let vc = viewController?.topViewController as? ViewController
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  SoundManager.shared.playAlarmSound()// ViewController içindeki playAlarmSound fonksiyonunu çağırma
              }
          }
          
          completionHandler([.alert, .sound])
      }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let type = response.notification.request.identifier
        switch type {
        case "alarm":
            if let navigationController = window?.rootViewController as? UINavigationController {
                let vc = StopAlarmViewController()
                   navigationController.pushViewController(vc, animated: true)
               }
               
        default:
            break
        }
    }
}
