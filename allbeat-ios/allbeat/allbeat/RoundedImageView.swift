//
//  AlbumArtImageView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/13/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView: UIView {
	@IBInspectable var targetImage: UIImage? {
		didSet {
			// Change the image and tell it to redisplay
			imageLayer.contents = targetImage?.cgImage
			layer.setNeedsDisplay()
		}
	}
	
	private var imageLayer: CALayer = CALayer()
	private var cornerRadius: CGFloat = 5
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	init(image: UIImage, frame: CGRect) {
		super.init(frame: frame)
		
		targetImage = image
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
		// Configure the layer
		backgroundColor = UIColor.lightGray
		layer.cornerRadius = cornerRadius
		
		// Shadow the image
		layer.shadowRadius = 15
		layer.shadowOpacity = 0.4
		layer.shadowOffset = CGSize.zero
		
		// Configure the image layer
		imageLayer.cornerRadius = cornerRadius
		imageLayer.masksToBounds = true
		imageLayer.backgroundColor = UIColor.clear.cgColor
		layer.addSublayer(imageLayer)
	}
	
	override func layoutSubviews() {
		// Update the bounds of the image layer
		imageLayer.frame = layer.bounds
		
		// Update the shadow path
		layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), cornerRadius: cornerRadius).cgPath
	}
}
