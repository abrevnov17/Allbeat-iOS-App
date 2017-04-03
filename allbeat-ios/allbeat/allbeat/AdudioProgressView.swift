//
//  AdudioProgressView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/21/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class AudioProgressView: CircularProgressView {
	// Determines if should update based on current player
	var isActive: Bool = false {
		willSet(value) {
			// Don't repeat the step if it didn't change
			if value == isActive {
//				print("isActive was set again to the same value.")
				return
			}
			
			// Enable or disable display lini
			if value {
				displayLink?.add(to: RunLoop.main, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
			} else {
				displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
				progress = 0
			}
		}
	}
	
	// Link to getting updates every frame
	private var displayLink: CADisplayLink?
	
	override func setup() {
		super.setup()
		
		// Set up the display link
		displayLink = CADisplayLink(target: self, selector: #selector(AudioProgressView.update))
	}
	
	// Called up CADisplayLink update
	func update() {  
		if let percentComplete = AudioPlayer.sharedInstance.percentComplete , isActive {
			progress = CGFloat(percentComplete)
		} else {
			print("Called update() while inactive.")
		}
	}
}
