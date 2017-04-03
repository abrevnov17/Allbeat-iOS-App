//
//  TabBarSegue.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/12/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class TabBarSegue: UIStoryboardSegue {
	override func perform() {
		// Check it's from the tab bar controller then register it
		if let tabBarController = source as? TabBarController {
			tabBarController.switchToViewController(destination)
		}
	}
}
