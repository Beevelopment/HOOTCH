//
//  AppDelegate.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/26/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6662079405759550~6086892906")
        PurchaseManaager.instance.fetchProducts()
        
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        
        let user = UIDevice.current.identifierForVendor!.uuidString
        let dict = ["userUid": user]
        DataService.instance.createFirebaseUser(uid: user, user: dict)
        UserDefaults.standard.set(user, forKey: "UID")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
}

