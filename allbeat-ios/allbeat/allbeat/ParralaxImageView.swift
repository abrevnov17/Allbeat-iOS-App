//
//  ParralaxImageView.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/18/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class ParralaxImageView: UIView {
	// The image to blur
	@IBInspectable var targetImage: UIImage? {
		didSet {
			// Set the image
			layer.contents = targetImage?.cgImage
		}
	}
	
	// Returns a center position on the global coordinate scale
	private var globalCenter: CGPoint {
		return convert(center, to: nil)
	}
	
	// Link to getting updates every frame
	private var displayLink: CADisplayLink!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setup()
	}
	
	func setup() {
		#if !TARGET_INTERFACE_BUILDER
		// Set up the display link
		displayLink = CADisplayLink(target: self, selector: #selector(update))
		displayLink.add(to: RunLoop.main, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
		#endif
		
		// Setup the view
		backgroundColor = UIColor.darkGray
	}
	
	#if !TARGET_INTERFACE_BUILDER
	// Called once a frame to update teh look
	func update() {
		// Change the image offset based on the global position
		if let _ = targetImage , layer.contents != nil {
			// Fit the bounds to the image square
			var newContentsRect = layer.bounds.aspectFitRect(CGRect(x: 0, y: 0, width: 1, height: 1))
			
			// Move the content rect to reflect its amount of way down the screen
			let t = globalCenter.y / UIScreen.main.bounds.height
			newContentsRect.origin.y = t * (1 - newContentsRect.height)
			
			// Fit the bounds to the image square
			if layer.contentsRect != newContentsRect {
				layer.contentsRect = newContentsRect
			}
		}
	}
	
	deinit {
		// Remove the display link
		displayLink.invalidate()
	}
	#endif
}
