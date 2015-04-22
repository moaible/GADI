//
//  AppDelegate.swift
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/20.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var navigationController: UINavigationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.navigationController = UINavigationController(rootViewController:AppleViewController())
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        
        GADInjector.injectWithTrackingID(
            "",
            configPropertyListPath:NSBundle.mainBundle().pathForResource("GoogleAnalyticsConfig.plist", ofType: ""))
        
        return true
    }
}
