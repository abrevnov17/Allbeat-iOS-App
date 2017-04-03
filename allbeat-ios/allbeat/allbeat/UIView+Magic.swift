//
//  UIView+Magic.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/8/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

extension UIView {
	func forceLayout() {
		self.setNeedsUpdateConstraints()
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	func snapshotView() -> UIImage {
		UIGraphicsBeginImageContext(bounds.size)
		let context = UIGraphicsGetCurrentContext()
		layer.render(in: context!)
		let capture = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return capture!
	}
	
	func addQuickConstraints(_ constraints: [(String, NSLayoutFormatOptions?)], views: [String: UIView], metrics: [String: CGFloat]? = nil) {
		for (_, view) in views {
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		var combinedConstraints = [NSLayoutConstraint]()
		for (format, options) in constraints {
			combinedConstraints += NSLayoutConstraint.constraints(
				withVisualFormat: format,
				options: options != nil ? options! : [],
				metrics: metrics,
				views: views
			)
		}
		
		addConstraints(combinedConstraints)
	}
}

extension UILabel {
	func textSize() -> CGSize {
		return NSString(string: text ?? "").size(attributes: [ NSFontAttributeName: font ])
	}
	
	func isTruncated() -> Bool {
		let stringSize = textSize()
		return stringSize.width > bounds.width || stringSize.height > bounds.height
	}
}
