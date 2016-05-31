//
//  AppDelegate.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.setupWindow()
        return true
    }
    
    private func setupWindow() {
        let screenBounds = UIScreen.mainScreen().bounds
        let viewController = MapViewController()
        let root = NavigationController(rootViewController: viewController)
        let window = UIWindow(frame: screenBounds)
        window.rootViewController = root
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

