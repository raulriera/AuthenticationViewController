//
//  AppDelegate.swift
//  Example
//
//  Created by Raúl Riera on 04/11/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import UIKit
import AuthenticationViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        // Before doing this, you should check the url is your redirect-uri before doing anything. Be safe :)
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems, let code = queryItems.first?.value {
            
            // Let's find the instance of our authentication controller, it would be the presentedViewController. This is another reason to check before that we are actually coming from the SFSafariViewController
            if let rootViewController = window?.rootViewController, let authenticationViewController = rootViewController.presentedViewController as? AuthenticationViewController {
                
                authenticationViewController.authenticateWithCode(code)
            }
            
            return true
        }
        
        return false
        
    }


}

