//
//  CommentData.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

class CommentData: Model {
	static let baseUrl: String = "comments"
	
	static let kPosterId = "posterId"
	static let kPostId = "postId"
	static let kMessage = "message"
	
	var id: String?
	var posterId: String?
	var postId: String
	var message: String
	
	init(posterId: String, postId: String, message: String) {
		self.posterId = posterId
		self.postId = postId
		self.message = message
	}
	
	required convenience init?(json: [String : Any]) {
		do {
			self.init(
				posterId: try (json[CommentData.kPosterId] as? String).unwrap(),
				postId: try (json[CommentData.kPostId] as? String).unwrap(),
				message: try (json[CommentData.kMessage] as? String).unwrap()
			)
			id = json["id"] as? String
		} catch {
			return nil
		}
	}
}