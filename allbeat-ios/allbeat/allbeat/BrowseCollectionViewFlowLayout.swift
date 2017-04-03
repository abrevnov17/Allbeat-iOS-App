//
//  BrowseCollectionViewFlowLayout.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/13/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class BrowseCollectionViewFlowLayout: UICollectionViewFlowLayout {
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}
