//
//  PromisedData.swift
//  allbeat
//
//  Created by Nathan Flurry on 5/6/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Alamofire

enum PromisedDataError: Error {
	case failedAutoLoad, failedConversion(Any, AnyClass)
	
//	var description: String {
//		return "\(self)" // TODO: Better errros
//	}
//   typealias RawValue = String
//    var rawValue: RawValue {
//        return "\(self)"
//    }
//    init?(rawValue: RawValue) {
//        self = rawValue =  "\(self)"
//    }
}

class PromisedData<T: JSONInitializable> {
	typealias Callback = (PromisedData, Error?) -> Void
	typealias CustomHandler = (PromisedData) -> T
	
	// Returns if the data exists
	var hasData: Bool {
		return data != nil
	}
	
	// The loaded data
	var data: T?
	
	// The URL of the data to load
	let url: NSURL
	
	// The handler for the data
	let customHandler: CustomHandler?
	
	init(url: NSURL, customHandler: CustomHandler? = nil) {
		self.url = url
		self.customHandler = customHandler
	}
	
	init(url: NSURL, automaticLoadCallback: Callback? = nil, customHandler: CustomHandler? = nil) throws {
		self.url = url
		self.customHandler = customHandler
		
		// If it should be automatically loaded, load the data
		if let callback = automaticLoadCallback {
			try getData(callback)
		}
	}
	
	// Fetches the data from the promise
   
	func getData(_ callback: @escaping Callback) throws {
        /*
		allbeatRequest(.get, path: "").responseJSON { response in
			switch response.result {
			case .success(let json):
				if let json = json as? [String: Any], let data = T(json: json) {
					self.data = data
					callback(self, nil)
				} else {
//					callback(self, PromisedDataError.failedConversion(json, T.self)) // TODO: Why the fuck is this line not working?
				}
			case .failure(let error):
				callback(self, error)
			}
 
 
		}
 */
	}
}
