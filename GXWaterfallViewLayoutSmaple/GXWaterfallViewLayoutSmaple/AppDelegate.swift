//
//  AppDelegate.swift
//  GXWaterfallViewLayoutSmaple
//
//  Created by Gin on 2021/1/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var window: UIWindow? {
        let _window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        _window.backgroundColor = UIColor.black
        return _window
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let vc = ViewController(nibName: "ViewController", bundle: nil)
        let navc = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navc;
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

