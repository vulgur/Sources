//
//  AppDelegate.swift
//  CodeReader
//
//  Created by vulgur on 16/5/8.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        Fabric.with([Answers.self, Crashlytics.self])
        

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        RecentsManager.sharedManager.save(RecentsManager.SaveType.Recent)
        RecentsManager.sharedManager.save(RecentsManager.SaveType.Favorite)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            if let recentsData = NSUserDefaults.standardUserDefaults().objectForKey("favorites") {
                RecentsManager.sharedManager.favorites = NSKeyedUnarchiver.unarchiveObjectWithData(recentsData as! NSData) as! [Recent]
                print("Favorites loaded")
            }
            if let recentsData = NSUserDefaults.standardUserDefaults().objectForKey("recents") {
                RecentsManager.sharedManager.recents = NSKeyedUnarchiver.unarchiveObjectWithData(recentsData as! NSData) as! [Recent]
                print("Recents loaded")
            }
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

