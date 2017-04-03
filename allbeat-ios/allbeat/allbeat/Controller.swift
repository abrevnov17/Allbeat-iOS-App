//
//  Controller.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

protocol Controller {
	associatedtype T
	associatedtype Callback = (T, Error) -> Void
	
	func index(_ callback: Callback)
	
	func store(_ model: T, callback: Callback)
	
	func show(_ id: String, callback: Callback)
	
	func update(_ model: T, parameters: [String: Any], callback: Callback)
	
	func destroy(_ model: Model, callback: Callback)
}
