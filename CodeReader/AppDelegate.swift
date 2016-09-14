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
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.black
        
        Fabric.with([Answers.self, Crashlytics.self])
        
        let console = ConsoleDestination()
        log.addDestination(console)
        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        RecentsManager.sharedManager.save(RecentsManager.SaveType.Recent)
        RecentsManager.sharedManager.save(RecentsManager.SaveType.Favorite)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            if let recentsData = UserDefaults.standard.object(forKey: "favorites") {
                RecentsManager.sharedManager.favorites = NSKeyedUnarchiver.unarchiveObject(with: recentsData as! Data) as! [Recent]
                print("Favorites loaded")
            }
            if let recentsData = UserDefaults.standard.object(forKey: "recents") {
                RecentsManager.sharedManager.recents = NSKeyedUnarchiver.unarchiveObject(with: recentsData as! Data) as! [Recent]
                print("Recents loaded")
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

