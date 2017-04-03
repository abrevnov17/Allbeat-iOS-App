//
//  ArcView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/12/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable class ArcView: UIView {
	@IBInspectable var startAngle: CGFloat = CGFloat(-M_PI_2)
	@IBInspectable var endAngle: CGFloat = 0
	@IBInspectable var clockwise: Bool = true
	
	@IBInspectable var lineWidth: CGFloat = 1
	@IBInspectable var lineCap: CGLineCap = CGLineCap.butt
	
	@IBInspectable var color: UIColor = UIColor.black
	
	override func draw(_ rect: CGRect) {
		let arc = UIBezierPath(arcCenter: CGPoint.zero, radius: min(rect.width, rect.height), startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
		
		var a = CGAffineTransform.identity
		
		let path = CGPath(
			__byStroking: arc.cgPath,
			transform: withUnsafePointer(to: &a, { $0 }),
			lineWidth: lineWidth,
			lineCap: lineCap,
			lineJoin: CGLineJoin.round,
			miterLimit: 0
		)
		
		let context = UIGraphicsGetCurrentContext()
		
		context?.addPath(path!)
		
		context?.setFillColor(color.cgColor)
		
		context?.fillPath()
	}
}
