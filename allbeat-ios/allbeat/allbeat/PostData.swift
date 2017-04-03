//
//  PostData.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class PostData: Model {
	static let baseUrl: String = "posts"
	
	static let kPosterId = "posterId"
	static let kTitle = "title"
	static let kDescription = "description"
	static let kAudio = "audio"
	
	var id: String?
	var posterId: String
	var title: String
	var desc: String
	var audio: S3Object
	
	var albumArt: UIImage?
	
	init(posterId: String, title: String, desc: String, audioKey: String) {
		self.posterId = posterId
		self.title = title
		self.desc = desc
		self.audio = S3Object(location: .audio, key: audioKey)
	}
	
	required convenience init?(json: [String : Any]) {
		do {
			self.init(
				posterId: try (json[PostData.kPosterId] as? String).unwrap(), // TODO: Use Int instead
				title: try (json[PostData.kTitle] as? String).unwrap(),
				desc: try (json[PostData.kDescription] as? String).unwrap(),
				audioKey: try (json[PostData.kAudio] as? String).unwrap()
			)
			id = json["id"] as? String
		} catch {
			return nil
		}
	}
	
	func getAlbumArt(_ callback: @escaping (PostData, S3DownloadError?) -> Void) {
		audio.download { (data, error) in
			callback(self, error)
		}
	}
}
