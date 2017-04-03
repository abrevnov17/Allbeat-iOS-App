//
//  GradientView.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/18/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
	/* Parameters */
	@IBInspectable var startColor: UIColor = UIColor.white {
		didSet {
			setupGradient()
		}
	}
	
	@IBInspectable var endColor: UIColor = UIColor.black {
		didSet {
			setupGradient()
		}
	}
	
	@IBInspectable var startPoint: CGPoint = CGPoint.zero {
		didSet {
			setupGradient()
		}
	}
	
	@IBInspectable var endPoint: CGPoint = CGPoint.init(x: 1, y: 1) {
		didSet {
			setupGradient()
		}
	}
	
	/* Fields */
	private var gradientLayer: CAGradientLayer!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setup()
	}
	
	
	private func setup() {
		// Create the gradient layer
		gradientLayer = CAGradientLayer()
		layer.addSublayer(gradientLayer)
		
		// Setup the gradient
		setupGradient()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		gradientLayer.frame = layer.bounds
	}
	
	private func setupGradient() {
		// Move gradient layer under other views
		gradientLayer.zPosition = -10
		
		// Setup the gradient
		gradientLayer.colors = [ startColor.cgColor, endColor.cgColor ]
		gradientLayer.locations = [ 0, 1 ]
		gradientLayer.startPoint = startPoint
		gradientLayer.endPoint = endPoint
	}
}
