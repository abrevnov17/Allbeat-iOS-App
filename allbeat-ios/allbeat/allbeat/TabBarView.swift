//
//  TabBarView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/12/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class TabBarView: UIVisualEffectView {
	override init(effect: UIVisualEffect?) {
		super.init(effect: effect)
		
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setup()
	}
	
	override func prepareForInterfaceBuilder() {
		setup()
	}
	
	func setup() {
		layer.shadowRadius = 1
		layer.shadowOpacity = 0.5
		layer.shadowOffset = CGSize.zero
		
		clipsToBounds = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Adjust the shadow path for the new frame
		layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)).cgPath
	}
}
