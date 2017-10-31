                            //
//  AppDelegate.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 4/10/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        print("Configed")
        
        UINavigationBar.appearance().tintColor = Colors.yesColor
        UINavigationBar.appearance().backgroundColor = UIColor.white
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-4506238853860646~5403155217")
        // theme this application!
        /* let hackerGreen = UIColor(red: 32.0/255.0, green: 194.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        let sharedApplication = UIApplication.shared
            sharedApplication.delegate?.window??.tintColor = hackerGreen
            sharedApplication.delegate?.window??.backgroundColor = UIColor.black
            UINavigationBar.appearance().tintColor = hackerGreen
            UINavigationBar.appearance().barStyle = .blackOpaque
            UINavigationBar.appearance().isOpaque = true
            //UINavigationBar.appearance().barTintColor = UIColor.black

            UITabBar.appearance().barTintColor = UIColor.black
            UITabBar.appearance().barStyle = .black

            UISearchBar.appearance().barStyle = .black
            UISearchBar.appearance().tintColor = hackerGreen
            UISearchBar.appearance().changeSearchBarColor(color: hackerGreen)
            if #available(iOS 9.0, *) {
                //UILabel.appearance().textColor = hackerGreen
            } else {
                //UILabel.appearance().textColor = hackerGreen
                //UILabel.appearance().tintColor = hackerGreen
                UIButton.appearance().tintColor = hackerGreen

            }
            //UIImageView.appearance().tintColor = hackerGreen
            UITableViewCell.appearance().backgroundColor = UIColor.darkGray
            UITextField.appearance().backgroundColor = UIColor.black
            UITextField.appearance().borderStyle = .line
            //UITextField.appearance().textColor = hackerGreen
            UITextField.appearance().font = UIFont(name: "Menlo", size: 14)
            //UIScrollView.appearance().backgroundColor = UIColor.darkGrayColor()
            UITableView.appearance().backgroundColor = UIColor.darkGray
            let view = UIView()
            view.backgroundColor = UIColor.gray
            UITableViewCell.appearance().selectedBackgroundView = view

            //UITableViewCell.appearance().textLabel?.textColor = hackerGreen
           // UINavigationBar.appearance().backgroundColor = UIColor.blackColor()*/
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

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
