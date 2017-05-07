//
//  AppDelegate.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/8/15. Modified by Anatoly Brevnov on 3/27/17.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//


import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      

        
        if !UserDefaults.standard.bool(forKey: "TermsAccepted") {
            
            //terms and conditions accepted...probably should actually implement eventually but i need to get that document from the higher ups
            UserDefaults.standard.set(true, forKey: "TermsAccepted")
            
            //switching root controller to the tutorial -> just happens on first load
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialPageViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        
        
        
        }
		
		// Prints all the fonts
//		for i in 0..<UIFont.familyNames().count {
//			print("\(UIFont.familyNames()[i]) \(UIFont.fontNamesForFamilyName(UIFont.familyNames()[i]))")
//		}
        FIRApp.configure() //enables Firebase
        
        FIRDatabase.database().persistenceEnabled = true
		// Set appearance
               
       UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor(hex: 0x4A90E2)
       
		UINavigationBar.appearance().tintColor = UIColor.white
		UINavigationBar.appearance().barTintColor = UIColor(hex: 0x4A90E2)
		UINavigationBar.appearance().titleTextAttributes = [
			NSForegroundColorAttributeName: UIColor.white,
			NSFontAttributeName: UIFont(name: "Raleway-Medium", size: 24)!
		]
		
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
}

