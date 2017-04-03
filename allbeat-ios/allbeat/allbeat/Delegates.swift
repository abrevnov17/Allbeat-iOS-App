//
//  Delegates.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/8/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

class Delegates<T: AnyObject> {
	// Lists of delegates subscribed to changes
	var delegates: [Weak<T>]
	
	init() {
		delegates = []
	}
	
	// Add a delegate to the list
	func register(_ newDelegate: T) {
		delegates += [ Weak(value: newDelegate) ]
	}
	
	// Removes a delegate from the list
	func unregister(_ oldDelegate: T) {
		for (index, delegate) in delegates.enumerated() {
			if delegate.value === oldDelegate {
				delegates.remove(at: index)
				return
			}
		}
	}
	
	// Sends an event to all teh delegates
	func trigger(_ callback: (T) -> Void) {
		for (index, delegate) in delegates.enumerated() {
			if let subscriber = delegate.value {
				callback(subscriber)
			} else {
				delegates.remove(at: index)
			}
		}
	}
}
