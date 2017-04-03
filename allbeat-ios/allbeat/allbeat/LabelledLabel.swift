//
//  SubtitleLabel.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/16/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable class LabelledLabel: UILabel {
	@IBInspectable var title: String? {
		didSet {
			updateText()
		}
	}
	
	@IBInspectable var content: String? {
		didSet {
			updateText()
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
		// Set up the text attributes
		textAlignment = .left
		numberOfLines = 2
		
		// Set the text
		updateText()
	}
	
	func updateText() {
		let attributedString = NSMutableAttributedString(
			string: "\(title ?? "Label")\n",
			attributes: [
				NSFontAttributeName: UIFont(name: "Raleway-Light", size: 12)!
			]
		)
        let add = NSAttributedString(
            string: content ?? "Text",
            attributes: [
                NSFontAttributeName: UIFont(name: "Raleway-SemiBold", size: 19)!
            ]
        )
		attributedString.append(add)
		
		
		attributedText = attributedString
	}
}
