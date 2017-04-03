//
//  Array+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/19/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import Foundation

extension Array {
	func random() -> Element {
		return self[ Int.random() % self.count ]
	}
	
	mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
		for (index, objectToCompare) in self.enumerated() {
			if let to = objectToCompare as? U {
				if object == to {
					self.remove(at: index)
					return true
				}
			}
		}
		return false
	}
}

extension Collection {
	/// Return a copy of `self` with its elements shuffled
	func shuffle() -> [Iterator.Element] {
		var list = Array(self)
		list.shuffleInPlace()
		return list
	}
}

extension MutableCollection where Index == Int {
	/// Shuffle the elements of `self` in-place.
	mutating func shuffleInPlace() {
		// Make sure count is an Int and there are enough elements to shuffle
		guard let count = count as? Int else { print("Can't convert IndexDistance to Int"); return }
		guard count >= 2 else { return }
		
		for i in 0..<count - 1 {
			let j = Int(arc4random_uniform(UInt32(count - i))) + i
			guard i != j else { continue }
			swap(&self[i], &self[j])
		}
	}
}
