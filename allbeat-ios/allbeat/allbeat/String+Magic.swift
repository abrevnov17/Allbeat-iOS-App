//
//  String+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import Foundation

extension String {
	subscript(integerIndex: Int) -> Character {
		let index = characters.index(startIndex, offsetBy: integerIndex)
		return self[index]
	}
	
	subscript(integerRange: Range<Int>) -> String {
		let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
		let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
		let range = start..<end
		return self[range]
	}
	
	static func randomString(_ length: Int, characterSet: String? = nil) -> String {
		let chars = characterSet ?? "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		var str = ""
		for _ in 1...length {
			str.append(chars[Int(arc4random()) % chars.characters.count])
		}
		return str
	}
}
