//
//  TextboxCollectionViewCell.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/9/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class TextboxCollectionViewCell: UICollectionViewCell {
	override var bounds: CGRect {
		didSet {
			contentView.frame = bounds
		}
	}
	
	@IBOutlet weak var textbox: UITextField!
	
	var placeholder = "Textbox" {
		didSet {
			textbox.placeholder = placeholder
		}
	}
	
	override func layoutSubviews() {
		// Update the textbox placeholder
		textbox.placeholder = placeholder
	}
	
}