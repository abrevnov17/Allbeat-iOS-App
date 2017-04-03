//
//  CircularProgressView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/20/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit


@IBDesignable class CircularProgressView: UIView {
	@IBInspectable var progress: CGFloat = 0.5 {
		didSet {
			generate()
		}
	}
	@IBInspectable var lineWidth: CGFloat = 1 {
		didSet {
			progressLayer.lineWidth = lineWidth
			generate()
		}
	}
	
	@IBInspectable override var tintColor: UIColor? {
		didSet {
			progressLayer.strokeColor = tintColor?.cgColor
		}
	}
	
	private var progressLayer: CAShapeLayer = CAShapeLayer()
	
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
		backgroundColor = UIColor.clear
		
		progressLayer.contentsScale = UIScreen.main.scale
		progressLayer.strokeColor = tintColor?.cgColor
		progressLayer.fillColor = nil
		progressLayer.lineCap = kCALineCapButt
		progressLayer.fillRule = kCAFillRuleNonZero
		layer.addSublayer(progressLayer)

		generate()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		progressLayer.frame = layer.bounds
		generate()
	}
	
	func generate() {
		// Get the metrics of the arc
		let center = CGPoint(x: progressLayer.bounds.width / 2, y: progressLayer.bounds.height / 2)
		let radius = (progressLayer.bounds.width - lineWidth) / 2
		let startAngle: CGFloat = CGFloat(-M_PI_2)
		let endAngle: CGFloat = progress * CGFloat(M_PI) * 2 + startAngle
		
		// Generate the arc
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		path.lineCapStyle = CGLineCap.butt
		path.lineWidth = lineWidth
		
		// Assign the path
		progressLayer.path = path.cgPath
	}
}
