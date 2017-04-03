//
//  AudioPlayer.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/16/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import AVFoundation

class AudioPlayer: NSObject {
	static var sharedInstance = AudioPlayer()
	
	// Used to determine the next song
	var delegates: Delegates<AudioPlayerDelegate> = Delegates<AudioPlayerDelegate>()
	
	// Used to determine the next song, not weak because this is the only instance holding a reference to it
	var dataSource: AudioPlayerDataSource?
	
	// Plays the audio
	var audioPlayer: AVAudioPlayer?
	
	// Returns the percent completle
	var percentComplete: TimeInterval? {
		get {
			if let audioPlayer = audioPlayer {
				return audioPlayer.currentTime / audioPlayer.duration
			} else {
				return nil
			}
		}
		set(percentComplete) {
			if let audioPlayer = audioPlayer, let percentComplete = percentComplete {
				audioPlayer.currentTime = percentComplete * audioPlayer.duration
			} else {
				print("Can not change percentComplete if audioPlayer is nil or value is nil.")
			}
		}
	}
	
	// Returns the length of the track
	var currentTime: TimeInterval? {
		get {
			if let audioPlayer = audioPlayer {
				return audioPlayer.currentTime // TODO: Maybe use deviceCurrentTime?
			} else {
				return nil
			}
		}
		set(currentTime) {
			if let audioPlayer = audioPlayer, let currentTime = currentTime {
				audioPlayer.currentTime = currentTime
			} else {
				print("Can not change currentTime if audioPlayer is nil or value is nil.")
			}
		}
	}
	
	// Returns the length of the track
	var trackDuration: TimeInterval? {
		if let audioPlayer = audioPlayer {
			return audioPlayer.duration
		} else {
			return nil
		}
	}
	
	// Used to easily start and stop the audio
	var playing: Bool {
		get {
			// Return if the player is playing, if it exists
			if let player = audioPlayer {
				return player.isPlaying
			} else {
				return false
			}
		}
		set(playing) {
			// Play or pause the player, if it exists
			if let player = audioPlayer {
				if playing {
					player.play()
					delegates.trigger { $0.played(self) }
				} else {
					player.pause()
					delegates.trigger { $0.paused(self) }
				}
			} else {
				print("Can't play or pause, there is no audio player.")
			}
		}
	}
	
	// The index currently playing at
	private(set) var playingIndex: Int?
	
	// Called when moving to next song
    func next(url: String) {
		// Play the next song
        playAtIndex(index: (playingIndex ?? 0) + 1, url: url)
	}
	
	// Called when you want to begin the song and the playing index is already correct
    func playAtIndex(index: Int, url:String, notifyFinished: Bool = true) {
		// Notify the delegates if needed
		if notifyFinished {
			delegates.trigger { $0.finishedAudio(self) }
		}
		
		// Request the next audio piece with a callback
		dataSource?.nextAudioPiece(index, url: url, callback: nextAudioPiece)
	}
	
	// Stops the track
	func stop() {
		// Remove the adio player
		audioPlayer?.stop()
		audioPlayer = nil
		delegates.trigger { $0.stopped(self) }
	}
	
	private func nextAudioPiece(_ action: AudioDataSourceCallbackAction) {
		print("Next audio piece called with action \(action)")
		switch action {
		case .next(let index, let data, let fileTypeHint):
			playingIndex = index
			createAudioPlayer(data as Data, fileTypeHint: fileTypeHint) // Create the next audio player and play
		case .finished:
			stop() // Stop the audio
		}
	}
	
	// Creates an audio player to play the audio
	private func createAudioPlayer(_ data: Data, fileTypeHint fileHint: String, playAutomatically play: Bool = true) {
		do {
			// Set the type of playback
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
			
			// Say that it's playing audio
			try AVAudioSession.sharedInstance().setActive(true)
			
			// Create a player
			try audioPlayer = AVAudioPlayer(data: data, fileTypeHint: fileHint)
			audioPlayer?.delegate = self
			
			// Start playing, if requested
			self.playing = play
			
			// Notify delegate
			delegates.trigger { $0.beganAudio(self) }
		} catch {
			print("Error creating audio player.\n\(error)")
		}
	}
}

extension AudioPlayer: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		// Play the next song
		//next()
	}
}
