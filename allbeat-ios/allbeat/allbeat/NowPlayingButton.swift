//
//  NowPlayingButton.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/12/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

@IBDesignable class NowPlayingButton: UIButton {
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
		// Style the view
		backgroundColor = UIColor.gray
		layer.cornerRadius = min(bounds.width, bounds.height) / 2
		layer.masksToBounds = true
		
		// Subscribe as a delegate
		AudioPlayer.sharedInstance.delegates.register(self)
	}
	
	func updateState(_ audioPlayer: AudioPlayer) {
		// TODO: Update play/paused shown
		// TODO: Update time
		// TODO: Update image if needed
	}
}

extension NowPlayingButton: AudioPlayerDelegate {
	func timeChanged(_ audioPlayer: AudioPlayer, time: Float) {
		updateState(audioPlayer)
	}
	
	func stopped(_ audioPlayer: AudioPlayer) {
		updateState(audioPlayer)
	}
	
	func paused(_ audioPlayer: AudioPlayer) {
		updateState(audioPlayer)
	}
	
	func played(_ audioPlayer: AudioPlayer) {
		updateState(audioPlayer)
	}
	
	func beganAudio(_ audioPlayer: AudioPlayer) {
		updateState(audioPlayer)
	}
	
	func finishedAudio(_ audioPlayer: AudioPlayer) {
		updateState(audioPlayer)
	}
	
	func noLongerDelegate(_ audioPlayer: AudioPlayer) {
		updateState(audioPlayer)
	}
}
