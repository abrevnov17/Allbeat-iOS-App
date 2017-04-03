//
//  CGRect+Magic.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/13/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

extension CGRect {
	func scaleToAspectFitRect(_ target: CGRect) -> CGFloat {
		// Try to match width
		let s = target.width / self.width
		
		// If we scale the height to make the widths equal, does it still fit?
		if (self.height * s <= target.height) {
			return s
		} else {
			// No, so match height instead
			return target.height / self.height
		}
	}
	
	func aspectFitRect(_ target: CGRect) -> CGRect {
		let s = self.scaleToAspectFitRect(target)
		let w = self.width * s
		let h = self.height * s
		let x = target.midX - w / 2
		let y = target.midY - h / 2
		return CGRect(x: x, y: y, width: w, height: h)
	}
	
	func scaleToAspectFitAroundRect(_ target: CGRect) -> CGFloat {
		// Fit in the target inside the rectangle instead, and take the reciprocal
		return 1 / target.scaleToAspectFitRect(self)
	}
	
	func aspectFitAroundRect(_ target: CGRect) -> CGRect {
		let s = self.scaleToAspectFitAroundRect(target)
		let w = self.width * s
		let h = self.height * s
		let x = target.midX - w / 2
		let y = target.midY - h / 2
		return CGRect(x: x, y: y, width: w, height: h)
	}
}

/*func ScaleToAspectFitRectInRect(rFit: CGRect, _ rTarget: CGRect) -> CGFloat {
	// Try to match width
	let s = rTarget.width / rFit.width
	
	// If we scale the height to make the widths equal, does it still fit?
	if (rFit.height * s <= rTarget.height) {
		return s
	} else {
		// No, so match height instead
		return rTarget.height / rFit.height
	}
}

func AspectFitRectInRect(rFit: CGRect, rTarget: CGRect) -> CGRect {
	let s = ScaleToAspectFitRectInRect(rFit, rTarget)
	let w = rFit.width * s
	let h = rFit.height * s
	let x = rTarget.midX - w / 2
	let y = rTarget.midY - h / 2
	return CGRect(x: x, y: y, width: w, height: h)
}

func ScaleToAspectFitRectAroundRect(rFit: CGRect, _ rTarget: CGRect) -> CGFloat {
	// Fit in the target inside the rectangle instead, and take the reciprocal
	return 1 / ScaleToAspectFitRectInRect(rTarget, rFit)
}

func AspectFitRectAroundRect(rFit: CGRect, rTarget: CGRect) -> CGRect {
	let s = ScaleToAspectFitRectAroundRect(rFit, rTarget)
	let w = rFit.width * s
	let h = rFit.height * s
	let x = rTarget.midX - w / 2
	let y = rTarget.midY - h / 2
	return CGRect(x: x, y: y, width: w, height: h)
}*/
