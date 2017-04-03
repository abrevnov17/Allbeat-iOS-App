//
//  Weak.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/8/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

class Weak<T: AnyObject> {
	weak var value: T?
	
	init(value: T) {
		self.value = value
	}
}