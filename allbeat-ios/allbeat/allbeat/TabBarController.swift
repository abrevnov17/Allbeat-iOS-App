//
//  TabBarViewController.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/12/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class TabBarController: UIViewController, UINavigationControllerDelegate  {
	@IBOutlet private weak var activeView: UIView!
	
	static var singleton: TabBarController!
	
	private var activeViewController: UIViewController? = nil
	private var activeTabBarButton: TabBarButton? = nil
	
	@IBOutlet weak var tabBar: TabBarView!
	@IBOutlet weak var nowPlayingButton: NowPlayingButton!
	
	private let defaultSegue = "ToHome"
	@IBOutlet weak var defaultTabBarButton: TabBarButton!
	
	override func viewDidLoad() {
		TabBarController.singleton = self
		
       
        
        // Sets the default color of the background of the UITabBar
        self.tabBar.backgroundColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/225.0), alpha: 1.0)
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)

       
     
  
        
            // Sets the default color of the icon of the selected UITabBarItem and Title
        
    }
 

    
	
	override func viewDidAppear(_ animated: Bool) {
		// Trigger the default segue
		performSegue(withIdentifier: defaultSegue, sender: self)
        
		
		// Set the default tab bar icon as active
		defaultTabBarButton.tabActive = true
		
		// Set the active tab bar button to the default one
		activeTabBarButton = defaultTabBarButton
	}
	
	func setup() {
		
	}
	
	func switchToViewController(_ viewController: UIViewController) {
		// Remove current viewcontroller, if exists
		if let currentViewControler = activeViewController {
			currentViewControler.view.removeFromSuperview()
			currentViewControler.removeFromParentViewController()
		}
		
		// Save it as the active view controller
		activeViewController = viewController
		
		// Move the view controller into the view
		viewController.view.frame = activeView.bounds
		activeView.addSubview(viewController.view)
		addChildViewController(viewController)
		viewController.didMove(toParentViewController: self)
	}
	
	// Called, in addition to segue trigger, when tab bar button is tapped
	@IBAction func tabBarButtonTapped(_ sender: TabBarButton) {
		// Set the old tab to inactive
		activeTabBarButton?.tabActive = false
		
		// Set the tab to active
		sender.tabActive = true
		
		// Set the new active tab bar icon
		activeTabBarButton = sender
	}
	
//	 func preferredStatusBarStyle() -> UIStatusBarStyle {
//		return UIStatusBarStyle.lightContent
//	}
}
extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
