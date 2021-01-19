//
//  AppDelegate.swift
//  GXWaterfallViewLayoutSmaple
//
//  Created by Gin on 2021/1/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        let vc = ViewController(nibName: "ViewController", bundle: nil)
        let navc = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navc;
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

