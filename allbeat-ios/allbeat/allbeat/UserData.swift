//
//  UserData.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

class UserData: Model {
	static let baseUrl: String = "users"
	
	static let kUsername = "username"
	static let kDescription = "description"
	static let kProfilePicture = "profilePicture"
	
	var id: String?
	var username: String
	var desc: String
	var profilePicture: S3Object
	
	init(username: String, desc: String, profilePictureKey: String) {
		self.username = username
		self.desc = desc
		self.profilePicture = S3Object(location: .profilePicture, key: profilePictureKey)
	}
	
	required convenience init?(json: [String : Any]) {
		do {
			self.init(
				username: try (json[UserData.kUsername] as? String).unwrap(),
				desc: try (json[UserData.kDescription] as? String).unwrap(),
				profilePictureKey: try (json[UserData.kProfilePicture] as? String).unwrap()
			)
			id = json["id"] as? String
		} catch {
			return nil
		}
	}
}