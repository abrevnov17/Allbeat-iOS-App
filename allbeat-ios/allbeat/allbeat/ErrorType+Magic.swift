//
//  ErrorType+Magic.swift
//  allbeat
//
//  Created by Nathan Flurry on 5/9/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

extension Error {
	// Reporting errors for the lazy man
	func reportError() {
		// Print the error
		print("[ERROR] \(self)")
		
		// Present the error in the root view controller
		if let delegate = UIApplication.shared.delegate as? AppDelegate, let rootViewController = delegate.window?.rootViewController {
            let alertViewController = UIAlertController(title: "Error", message: String(describing: self), preferredStyle: .alert)
			rootViewController.present(
				alertViewController,
				animated: true,
				completion: nil
			)
		} else {
			print("Could not get root view controller to display error.")
		}
	}
}
