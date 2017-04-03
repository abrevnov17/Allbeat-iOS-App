//
//  BrowseDataSource.swift
//  allbeat
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

typealias BrowseRequestItemsCallback = (_ dataSource: BrowseDataSource, _ range: CountableRange<Int>, _ items: [BrowsingItem]) -> Void

protocol BrowseDataSource: class {
	func requestItems(_ range: CountableRange<Int>, callback: BrowseRequestItemsCallback)
}
