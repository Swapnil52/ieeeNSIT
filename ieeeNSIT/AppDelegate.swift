//
//  AppDelegate.swift
//  ieeeNSIT
//
//  Created by Swapnil Dhanwal on 10/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import UserNotifications
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Set up notifications
        let notificationsCenter = UNUserNotificationCenter.current()
        notificationsCenter.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
            
            
            
        }
        application.registerForRemoteNotifications()
        
        //set up calender access
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        //send the device token to our server
        var request = URLRequest(url: URL(string: "http://fgethell.xyz/iospushfinal/iospush.php?token=\(deviceTokenString)")!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error
            {
                
                DispatchQueue.main.async(execute: { 
                    
                    print(error.localizedDescription)
                    
                })
                
                
            }
            else
            {
                DispatchQueue.main.async(execute: { 
                    
                    if let data = data
                    {
                        
                        let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print(dataString!)
                    }
                    
                })
            }
            
            
        }
        task.resume()
        
        print(deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

