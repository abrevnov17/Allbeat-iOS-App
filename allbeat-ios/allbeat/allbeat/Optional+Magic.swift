//
//  Optional+Magic.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

//func ===<T: Equatable>(lhs: T?, rhs: T) -> Bool {
//	if let lhs = lhs where lhs == rhs {
//		return true
//	} else {
//		return false
//	}
//}
//
//func ===<T: Equatable>(lhs: T, rhs: T?) -> Bool {
//	return rhs == lhs
//}
//
//func ===<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
//	if let lhs = lhs, rhs = rhs {
//		return lhs == rhs
//	} else if lhs == nil && rhs == nil {
//		return false
//	} else if let lhs = lhs {
//		return lhs === rhs
//	} else if let rhs = rhs {
//		return lhs === rhs
//	}
//}

struct OptionalUnwrapError: Error {
	
}

extension Optional {
	func unwrap() throws -> Wrapped {
		if let value = self {
			return value
		} else {
			throw OptionalUnwrapError()
		}
	}
}
