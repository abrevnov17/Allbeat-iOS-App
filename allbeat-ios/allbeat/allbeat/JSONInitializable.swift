//
//  JSONInitializable.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

protocol JSONInitializable {
	init?(json: [String: Any])
}