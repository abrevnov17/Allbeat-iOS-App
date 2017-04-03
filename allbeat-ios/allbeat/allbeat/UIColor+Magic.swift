//
//  UIColor+Magic.swift
//  Jubel
//
//  Created by Nathan Flurry on 6/10/15.
//  Copyright © 2015 Jubel, LLC. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(hex: Int) {
		self.init(hex: hex, alpha: 1.0)
	}
	
	convenience init(hex: Int, alpha: CGFloat) {
		self.init(
			red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
			blue: CGFloat(hex & 0xFF) / 255.0,
			alpha: alpha)
	}
	
	convenience init?(hexString: String) {
		var cleanString = hexString.replacingOccurrences(of: "#", with: "")
		if cleanString.characters.count == 3 {
			let num1 = cleanString[0]
			let num2 = cleanString[1]
			let num3 = cleanString[2]
			cleanString = "\(num1)\(num1)\(num2)\(num2)\(num3)\(num2)"
		} else {
			print("String length must be 3 or 6.")
			return nil
		}
		
		var baseValue: UInt32 = 0
		guard Scanner(string: cleanString).scanHexInt32(&baseValue) == true else {
			print("Could not use NSScanner.")
			return nil
		}
		
		self.init(hex: Int(baseValue))
	}
	
	var red: CGFloat {
		get {
			return extractColors()[0]
		}
	}
	var green: CGFloat {
		get {
			return extractColors()[1]
		}
	}
	var blue: CGFloat {
		get {
			return extractColors()[2]
		}
	}
	var alpha: CGFloat {
		get {
			return extractColors()[3]
		}
	}
	
	var hex: Int {
		return  Int(red) * 256 * Int(green) * 256 * Int(blue) * 256 - 1
	}
	
	func color(alpha a: CGFloat) -> UIColor {
		return UIColor(red: red, green: green, blue: blue, alpha: a)
	}
	
	func extractColors() -> [CGFloat] {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return [red, green, blue, alpha]
	}
	
	func offsetColors(_ amnt: CGFloat) -> UIColor {
		var colors = extractColors()
		
		return UIColor(red: colors[0]+amnt, green: colors[1]+amnt, blue: colors[2]+amnt, alpha: colors[3])
	}
	
	func setAlpha(_ alpha: CGFloat) -> UIColor {
		var colors = extractColors()
		
		return UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: alpha)
	}
	
	func blend(color col:UIColor, location:CGFloat) -> UIColor {
		let bRed:CGFloat = location * (red + col.red);
		let bGreen:CGFloat = location * (green + col.green);
		let bBlue:CGFloat = location * (blue + col.blue);
		let bAlpha:CGFloat = location * (alpha + col.alpha);
		
		return UIColor(red: bRed, green: bGreen, blue: bBlue, alpha: bAlpha);
	}
	
	func readableForegroundColorForBackgroundColor() -> UIColor {
		let darknessScore: CGFloat = (((red * 255) * 299) + ((green * 255) * 587) + ((blue * 255) * 114)) / 1000
		
		if darknessScore > 125 {
			return UIColor.black
		} else {
			return UIColor.white
		}
	}
}
