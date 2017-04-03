//
//  Storage.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/8/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import Foundation

class Storage {
	// The storage keys
	struct StorageKeys {
		static var username = "username"
		static var password = "password"
	}

	// The user defaults
	static let userDefaults = UserDefaults.standard

	static func getUsername() -> String? {
		return userDefaults.string(forKey: StorageKeys.username)
	}

	static func getPassword() -> String? {
		return userDefaults.string(forKey: StorageKeys.password)
	}
}
