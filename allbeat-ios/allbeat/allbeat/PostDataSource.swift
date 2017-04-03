//
//  PostDataSource.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/11/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import AVFoundation
class PostDataSource: BrowseDataSource {
	enum Source {
		case feed, user(String)
	}
	
	// The total number of items in the data source
	var itemCount = -1
	
	// If the data source has reached the end
	var finished: Bool {
		var maxIndex = -1
		for (index, _) in items {
			if index > maxIndex {
				maxIndex = index
			}
		}
		return maxIndex >= itemCount
	}
	
	// Items loaded for the browsing
	var items: [Int: BrowsingItem] = [:]
	
	// Items loaded for the audio
	var audioItems: [Int: PostData] = [:]
	
	init(source: Source) {
		
	}
	
	func requestItems(_ range: CountableRange<Int>, callback: BrowseRequestItemsCallback) {
		// TODO: Request the items and add the mto loaded items
		callback(
            self,
            range,
            Array<BrowsingItem>(
				repeating: .post(
					PostData(posterId: "abc", title: "This is the title", desc: "Some description", audioKey: "audio key")
				),
				count: range.endIndex - range.startIndex + 1
			)
		)
	}
}

extension PostDataSource: AudioPlayerDataSource {
    func nextAudioPiece(_ index: Int, url: String, callback: AudioDataSourceCallback) {
//		if let audioItem = audioItems[index] {
//			loadAudio(audioItem, index: index, callback: callback)
//			print("Already has item \(audioItem), downloading.")
//		} else {
//			// TODO: Request the audio item from the server
//			// TODO: When it's loaded, call loadAudio()
//		}
		
        
		print("Requesting next audio piece in data source with index \(index)")
		
		// Get the data
        //let url = "http://picosong.com/cdn/d9a6d92d54cde1df60e6702cce8c1815.mp3"
        print ("url", url)
        let fileURL = NSURL(string: url)
        do {
            if (AVAsset.init(url: fileURL as! URL) as? AVAsset) != nil {
               
                do {
                  let soundData = try Data(contentsOf: fileURL as! URL)
                     callback(.next(index, soundData, "mp3"))
                    
                } catch  {
                    
                }
 
                 //callback(.next(index, soundData, "m4a"))
            }
        //let soundData = try Data(contentsOf: fileURL as! URL)
          
		//if let asset = NSDataAsset(name: "kakurenbo") {
			//callback(.next(index, soundData, "m4a"))
		//} else {
			//print("Could not load data")
		//}
        } catch {
           
        }
	}
    func exportAsset(asset:AVAsset, fileName:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
      
        print("saving to \(trimmedSoundFileURL.absoluteString)")
        
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
            print("sound exists")
        }
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputFileType = AVFileTypeAppleM4A
        exporter?.outputURL = trimmedSoundFileURL
        
        let duration = CMTimeGetSeconds(asset.duration)
        if (duration < 11.0) {
            print("sound is not long enough")
            return
        }
        // e.g. the first 5 seconds
        let startTime = CMTimeMake(0, 1)
        let stopTime = CMTimeMake(11, 1)
        let exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
        exporter?.timeRange = exportTimeRange
        
        
        // do it
        exporter?.exportAsynchronously(completionHandler: {
            switch exporter?.status {
                
          ////  case  AVAssetExportSessionStatus.failed:
               // print("export failed \(exporter?.error)")
           // case AVAssetExportSessionStatus.cancelled:
              //  print("export cancelled \(exporter?.error)")
            default:
                print("export complete")
            }
        })
    }
	
	private func loadAudio(_ post: PostData, index: Int, callback: @escaping AudioDataSourceCallback) {
		// TODO: Fetch the items from S3
		post.audio.download { (object, error) in
			if error != nil { // if let error = error {
				callback(.finished) // TODO: Deal with the error
			} else if let url = object.localUrl {
				if let data = try? Data(contentsOf: url as URL) { // TODO: Do this on a seperate thread as to not lock up the main thread?
					callback(.next(index, data, "mp3")) // TODO: Check it's the correct format
				} else {
					// TODO: Deal with the issue of no NSData
				}
			} else {
				callback(.finished) // TODO: Deal with the unhandled error
			}
		}
	}
}
