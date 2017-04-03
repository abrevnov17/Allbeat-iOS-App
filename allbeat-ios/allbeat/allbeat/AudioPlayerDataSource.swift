//
//  AudioPlayerDataSource.swift
//  allbeat
//
//  Created by Nathan Flurry on 4/18/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation

enum AudioDataSourceCallbackAction {
	case next(Int, Data, String) // Index, audio data, file type hint
	case finished // Finished all the audio
	// case advertizement // Maybe one day?
}

typealias AudioDataSourceCallback  = (AudioDataSourceCallbackAction) -> Void

protocol AudioPlayerDataSource : class {
    func nextAudioPiece(_ index: Int, url:String, callback: AudioDataSourceCallback)
}
