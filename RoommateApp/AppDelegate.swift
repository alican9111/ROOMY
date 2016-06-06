//
//  AppDelegate.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 18/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let APP_ID = "E6C36E04-D3DC-E250-FF88-AA621DC0D600"
    let SECRET_KEY = "C5284632-F886-A36D-FFB3-9B0FC53A5700"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    var window: UIWindow?
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        
        print("AppDelegate -> application:openURL: \(url.scheme)")
        print("AppDelegate -> application:openURL: = \(url)")
        
        DebLog.setIsActive(true)
        
        let backendless = Backendless.sharedInstance()
        let user = backendless.userService.handleOpenURL(url)
        if user != nil {
           // print("AppDelegate -> application:openURL: user = \(user)")
            

        
        }
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let backgroundcolor = UIColor(red: 0.22, green: 0.729, blue: 0.569, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = backgroundcolor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
        let image = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        
        
        image.layer.borderWidth=1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM) // if you don’t need the MediaService – you must remove the next line
        // Override point for customization after application launch.
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

