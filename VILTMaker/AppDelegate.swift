//
//  AppDelegate.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        connectToRealmServer()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func connectToRealmServer() {
        
//        if let user = RLMSyncUser.all.first {
//            RealmConstants.setDefaultUser(user: user.value)
//            
//        
//        } else {
        //    let credential: SyncCredentials = SyncCredentials.accessToken(RealmConstants.adminToken, identity: RealmConstants.identity)
        let credential: SyncCredentials = SyncCredentials.usernamePassword(username: RealmConstants.identity, password: RealmConstants.password, register: false)
        
            
            SyncUser.logIn(with: credential, server: RealmConstants.authURL, onCompletion: { [weak self] (user, error) in
                if let user = user {
                    print("set default user\(user)")
                    RealmConstants.setDefaultUser(user: user)

                } else if let error = error {
                    print("login failed \(error)")
                }
            })
//        }
        
    }


}

