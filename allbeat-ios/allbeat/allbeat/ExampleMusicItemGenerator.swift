//
//  ExampleMusicItemGenerator.swift
//  allbeat
//
//  Created by Nathan Flurry on 2/20/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

//class ExampleMusicItemGenerator {
//	// List of temporary data
//	var exampleData: [MusicPostData];
//	
//	init() {
//		// Set the data
//		exampleData = [
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "city", songName: "The City", albumName: "Adventure", artistName: "Madeon"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "beautiful", songName: "Beautiful Now (feat. John Bellion)", albumName: "True Colors", artistName: "Zedd"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "airborne", songName: "Airborne", albumName: "The Outbreak", artistName: "Zomboy"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "kaleidoscope", songName: "Kaleidoscope", albumName: "Abandon Ship", artistName: "Knife Party"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "daydreamer", songName: "Daydreamer", albumName: "Daydreamer", artistName: "Flux Pavilion"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "lights", songName: "Lights", albumName: "Lights", artistName: "Ellie Goulding"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "low", songName: "Get Low", albumName: "Money Sucks, Friends Rule", artistName: "Dillon Francis"),
//			//		ExampleMusicItemGenerator.generateAudioClipData(id: "wake", songName: "Wake Me Up", albumName: "Wake Me Up", artistName: "Avicii"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "4di", coverName: "4di", songName: "Skit", albumName: "", artistName: "4di"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "aintnolove", coverName: "aintnolove", songName: "Champion Babylon", albumName: "", artistName: "Ain't No Love"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "angelalanis1", coverName: "angelalanis", songName: "Believe in Me (Original Mix)", albumName: "", artistName: "Angel Alanis"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "angelalanis2", coverName: "angelalanis", songName: "Variant (Angel Alanis Mix)", albumName: "", artistName: "Angel Alanis"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "angelalanis3", coverName: "angelalanis", songName: "Mucho Triko", albumName: "", artistName: "Angel Alanis"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "anthonysheeha", coverName: "anthonysheeha", songName: "Transcendence (Decktonic Remix)", albumName: "", artistName: "Anthony Seeha"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "bluedot1", coverName: "bluedot", songName: "An Accumulation", albumName: "", artistName: "Blue Dot Sessions"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "bluedot2", coverName: "bluedot", songName: "Emmit Sprak", albumName: "", artistName: "Blue Dot Sessions"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "bryandivisions", coverName: "bryandivisions", songName: "Shivai", albumName: "", artistName: "Bryan Divisions"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "coldnoise1", coverName: "coldnoise", songName: "Frozen", albumName: "", artistName: "Coldnoise and Alexandre Guirad"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "coldnoise2", coverName: "coldnoise", songName: "Remember", albumName: "", artistName: "Coldnoise"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "coldnoise3", coverName: "coldnoise", songName: "Malaika", albumName: "", artistName: "Coldnoise"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "coldnoise4", coverName: "coldnoise", songName: "Rainy", albumName: "", artistName: "Coldnoise"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "decktonic", coverName: "decktonic", songName: "Union Square (Anthony Seeha Remix)", albumName: "", artistName: "Decktonic"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "frame1", coverName: "frame", songName: "Rocky Moon", albumName: "", artistName: "Frame"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "frame2", coverName: "frame", songName: "Dark Drone on the Wind", albumName: "", artistName: "Frame"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "gorowski", coverName: "gorowski", songName: "Emu in the Bass", albumName: "", artistName: "Gorowski"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "hyppfractal", coverName: "hyppfractal", songName: "Memories (remix)", albumName: "", artistName: "Hypp Fractal"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "jupiter", coverName: "jupiter", songName: "Routine", albumName: "", artistName: "Jupiter Makes Me scream"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "kai", coverName: "kai", songName: "Floret", albumName: "", artistName: "Kai Angel"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "kakurenbo", coverName: "kakurenbo", songName: "Tomadoi", albumName: "", artistName: "Kakurenbo"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "kesson", coverName: "kesson", songName: "February", albumName: "", artistName: "Kesson shoujo"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "kosta", coverName: "kosta", songName: "Шаги уходящей любви", albumName: "", artistName: "Kosta T"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "lesvicon", coverName: "lesvicon", songName: "Call me at Heaven", albumName: "", artistName: "Lesvicon Soul"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "lordkenny", coverName: "lordkenny", songName: "My Name is (remix)", albumName: "", artistName: "Lord Kenney"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "LvstTvpz", coverName: "LvstTvpz", songName: "LvstTvpz Intro", albumName: "", artistName: "2Lz"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "miami", coverName: "miami", songName: "Good News", albumName: "", artistName: "Miami Slice"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "microscopes", coverName: "microscopes", songName: "Dont Go Farther", albumName: "", artistName: "Microscopes"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "mike", coverName: "mike", songName: "Ocean Floor", albumName: "", artistName: "Mike B. Fort"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "nihilore1", coverName: "nihilore", songName: "Apricity", albumName: "", artistName: "Nihilore"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "nihilore2", coverName: "nihilore", songName: "Resistentialism", albumName: "", artistName: "Nihilore"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "nihilore3", coverName: "nihilore", songName: "The dissolution of collusion", albumName: "", artistName: "Nihilore"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "roulet", coverName: "roulet", songName: "Na Praia", albumName: "", artistName: "Roulet"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "kaffein", coverName: "kaffein", songName: "All that she wants", albumName: "", artistName: "Kaffein"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "simon", coverName: "simon", songName: "Metallic Attack", albumName: "", artistName: "Simon Mathewson"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "spcz1", coverName: "spcz", songName: "Ground", albumName: "", artistName: "SPCZ"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "spcz2", coverName: "spcz", songName: "Sphere", albumName: "", artistName: "SPCZ"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "sun", coverName: "sun", songName: "Schooner", albumName: "", artistName: "Sun sunych"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "track1", coverName: "track", songName: "Questions answered", albumName: "", artistName: "Track Jackit"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "track2", coverName: "track", songName: "Track Jack Yo body now", albumName: "", artistName: "Track Jackit"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "unclebibby1", coverName: "unclebibby", songName: "Happi", albumName: "", artistName: "Uncle Bibby"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "unclebibby1", coverName: "unclebibby", songName: "Home Basser", albumName: "", artistName: "Uncle Bibby"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "yusuke", coverName: "yusuke", songName: "To the Sea", albumName: "", artistName: "Yusuke Tsutsumi"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "zebrat1", coverName: "zebrat", songName: "Imagination", albumName: "", artistName: "Zebrat"),
//			ExampleMusicItemGenerator.generateAudioClipData(id: "zebrat2", coverName: "zebrat", songName: "A childish world", albumName: "", artistName: "Zebrat")
//		]
//		
//		// Shuffle the data
//		exampleData.shuffleInPlace()
//	}
//	
//	// Temporary function to generate AudioClipData // TEMP: This
//	private static func generateAudioClipData(id id: String, coverName: String, songName: String, albumName: String, artistName: String) -> MusicPostData {
//		return MusicPostData(
//			id: id,
//			albumArt: UIImage(named: coverName + "c")!,
//			title: songName,
//			album: albumName,
//			artist: artistName,
//			
//			likes: 20,
//			rebeats: 20,
//			comments: 20
//		)
//	}
//	
//	func itemCount() -> Int {
//		return exampleData.count
//	}
//	
//	func itemAtIndex(index: Int) -> MusicPostData {
//		return exampleData[index]
//	}
//	
//	func browsingItemAtIndex(index: Int) -> BrowsingItem? {
//		if index < exampleData.count {
//			return .Music(exampleData[index])
//		} else {
//			return nil
//		}
//	}
//}