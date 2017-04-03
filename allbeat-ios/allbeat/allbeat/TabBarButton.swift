//
//  TabBarButton.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/12/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable class TabBarButton: UIButton {
	var activeIndicator: CALayer = CALayer()
	
	@IBInspectable var tabActive: Bool = false {
		didSet {
			animateTabChange()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
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
		// Configure self
		clipsToBounds = true
		
		// Configure the active indicator
		activeIndicator.backgroundColor = UIColor(white: 0, alpha: 0.3).cgColor
		layer.addSublayer(activeIndicator)
		
		// Set inactive
		tabActive = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Adjust the frame/radius of the active indicator
	
	}
	
	
	// Animates a tab change animation
	private func animateTabChange() {
			}
}
