//
//  ButtonCollectionVIewCell.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/9/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
	override var bounds: CGRect {
		didSet {
			contentView.frame = bounds
		}
	}
	
	@IBOutlet weak var button: UIButton!
	
	var title = "Button" {
		didSet {
			button.titleLabel?.text = title
		}
	}
	
	override func layoutSubviews() {
		// Update the button title
		button.titleLabel?.text = title
	}
}
