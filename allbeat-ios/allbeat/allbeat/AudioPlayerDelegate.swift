//
//  AudioPlayerDelegate.swift
//  allbeat
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

@objc protocol AudioPlayerDelegate: class {
	func stopped(_ audioPlayer: AudioPlayer)
	func paused(_ audioPlayer: AudioPlayer)
	func played(_ audioPlayer: AudioPlayer)
	func beganAudio(_ audioPlayer: AudioPlayer)
	func finishedAudio(_ audioPlayer: AudioPlayer)
	
	func noLongerDelegate(_ audioPlayer: AudioPlayer)
}
