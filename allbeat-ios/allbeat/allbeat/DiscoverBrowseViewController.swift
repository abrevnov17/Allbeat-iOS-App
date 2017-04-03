//
//  DiscoverBrowseViewController.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 8/28/16. Credit for structure goes to Nathan Flurry.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Firebase

class DiscoverBrowseViewController: UICollectionViewController {
    private let audioClipCellId = "AudioClip"
    
    //we pass data in for this value from other view controller depending on what is clicked
    
    var name:String?
    
    //i need this to pass into segue
    var globalTrackIDToPass:String?
    
    var reloadNumber = 5
    
    
    //THIS IS BASICALLY A MODIFIED VERSION OF BROWSEVIEWCONTROLLER CLASS WITH A FEW EDITS BASED ON LOADED IN DATA
    
    // The delegate
    var dataSource: PostDataSource?
    
    // The array of loaded items
    var loadedItems = [BrowsingItem]()
    
    //string
    
    var trackIDSFull = [String]()
    var trackIDS = [String]()
    
    // If there is a pending request
    var pendingRequest = false
    
    // Indicates if reached the end of the items available
    var reachedEnd = false
    
    // Number of items to load at once
    var loadStep = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalTrackIDToPass = ""
        
        Allbeat.getChannelTracks(channelID: name!) { (channels: Array<String>?) in
            //we have an array of TrackIDS for the given channel
            self.trackIDSFull = channels!
            self.loadMore()
            
            self.dataSource = PostDataSource(source: .feed)
            
            // Update the cell size
            self.updateCellSize()
            
            // Load a initial items
            self.loadMoreItems()
            
            self.title=self.name
            
        }
        
        
        // TEMP: Load delegate count into loadStep
        
    }
    
    func loadMore(){
        
        //toly version of load more items
        
        if (trackIDSFull.count>=5){
            
            for  i in 0...4 {
                
                trackIDS.append(trackIDSFull[i])
                
            }
            trackIDSFull.removeSubrange(0...4)
            reloadNumber = trackIDS.count
            
        }
        else {
            
            trackIDS.append(contentsOf: trackIDSFull)
            trackIDSFull.removeAll()
            
        }
        
        
        self.collectionView?.reloadData()
        self.loadMoreItems()
        
    }
    
    func loadMoreItems() {
        // Notify if delegate is nil
        if dataSource == nil { print("Delegate is nil") }
        
        // Request the items
        pendingRequest = true
        dataSource?.requestItems(loadedItems.count..<(loadedItems.count + loadStep)) {
            (dataSource, range, items) in
            // Set no pending request
            self.pendingRequest = false
            
            // Set reached end if there were less items than expected
            if items.count < self.loadStep {
                self.reachedEnd = true
            }
            
            // If there are items, add them and reload the view
            if items.count != 0 {
                self.loadedItems += items
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.items?[0].image =  #imageLiteral(resourceName: "Home").withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[1].image = #imageLiteral(resourceName: "Disc").withRenderingMode(.alwaysOriginal)
        
        
        self.tabBarController?.tabBar.items?[2].image = #imageLiteral(resourceName: "Search").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[3].image = #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[4].image = #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal)
        // Register as a delegate
        AudioPlayer.sharedInstance.delegates.register(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "comment") {
            
            let yourNextViewController = (segue.destination as! CommentViewController)
            yourNextViewController.trackID = globalTrackIDToPass
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unregister as a delegate
        AudioPlayer.sharedInstance.delegates.unregister(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update the cell size
        updateCellSize(size)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        // Adjust the content inset to account for the tab bar
        var parentVC = parent
        while parentVC != nil {
            if let tabBarController = parentVC as? TabBarController {
                collectionView?.contentInset.bottom += tabBarController.tabBar.bounds.height
                return
            } else {
                parentVC = parentVC?.parent
            }
        }
    }
    
    // Updates the cell sizes based on the screen size
    func updateCellSize(_ screenSize: CGSize? = nil) {
        let screenSize = screenSize ?? view.bounds.size
        
        // Scales the cells to snap to widths
        let minWidth: CGFloat = 300
        var width = screenSize.width
        width /= max(floor(width / minWidth), 1)
        
        // Assign the size
        (collectionViewLayout as? BrowseCollectionViewFlowLayout)?.itemSize = CGSize(width: width, height: floor(width * 0.75))
    }
}

extension DiscoverBrowseViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackIDS.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //guard
        let item = indexPath.item /*else {
         print("Could not get item from index path \(indexPath).")
         return UICollectionViewCell()
         }*/
        
        switch loadedItems[item] {
        case .user(_):
        break // TODO: Add support for this
        case .post(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioClip", for: indexPath) as! AudioClipCell
            
            // Set the data
            cell.setData(data, index: item, trackID: trackIDS[item])
            
            
            // Set as the delegate
            cell.delegate = self
            
            // Tell it it's playing if it's the current playign index
            if item == AudioPlayer.sharedInstance.playingIndex {
                cell.activeAudioCell = true
                cell.playing = AudioPlayer.sharedInstance.playing
            } else {
                cell.activeAudioCell = false
            }
            
            if (item >= reloadNumber - 1){
                
                reloadNumber = reloadNumber + 5
                loadMore()

                
            }
            
            
            return cell
        case .comment(_):
            break // TODO: Add support for this
        }
        
        // TEMP: This is temporary
        print("INVALID CELL")
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //loadMoreItems
        
    }
}

extension DiscoverBrowseViewController: AudioPlayerDelegate {
    //	func nextAudioPiece(callback: AudioDataSourceCallback) {
    //		print("Next audio piece.")
    //
    //		// Start playing from beginning, if not playing at all
    //		if playingIndex == nil {
    //			playingIndex = 0
    //		}
    //
    //		// Get the next audio piece, if hasn't exceeded example data
    //		if playingIndex < loadedItems.count, case let .Post(music) = loadedItems[playingIndex!] {
    //			// TEMP: Tell album art its playing
    //			TabBarController.singleton.tempSongChanged(music.albumArt)
    //
    //			print("Played new audio piece.")
    //
    //			// Get the data
    //			if let id = music.id, dataAsset = NSDataAsset(name: id) {
    //				callback(.next(dataAsset.data, "mp3"))
    //			}
    //		} else {
    //			// TEMP: Tell album art its not playing
    //			TabBarController.singleton.tempSongChanged(nil)
    //
    //			// Can't play another audio piece, stop playing
    //			print("No more audio.")
    //			callback(.finished)
    //		}
    //	}
    
    func stopped(_ audioPlayer: AudioPlayer) {
        print("Stopped \(audioPlayer.playingIndex)")
        if let cell = cellAtIndex(index: audioPlayer.playingIndex) {
            cell.activeAudioCell = false
        }
    }
    
    func paused(_ audioPlayer: AudioPlayer) {
        print("Paused \(audioPlayer.playingIndex)")
        if let cell = cellAtIndex(index: audioPlayer.playingIndex) {
            cell.playing = false
        }
    }
    
    func played(_ audioPlayer: AudioPlayer) {
        print("Played \(audioPlayer.playingIndex)")
        if let cell = cellAtIndex(index: audioPlayer.playingIndex) {
            cell.playing = true
        }
    }
    
    func beganAudio(_ audioPlayer: AudioPlayer) {
        print("Began audio \(audioPlayer.playingIndex)")
        if let cell = cellAtIndex(index: audioPlayer.playingIndex) {
            cell.activeAudioCell = true
        }
    }
    
    func finishedAudio(_ audioPlayer: AudioPlayer) {
        print("Finished audio \(audioPlayer.playingIndex)")
        if let cell = cellAtIndex(index: audioPlayer.playingIndex) {
            cell.activeAudioCell = false
        }
    }
    
    func noLongerDelegate(_ audioPlayer: AudioPlayer) {
        print("No longer delegate \(audioPlayer.playingIndex)")
        if let cell = cellAtIndex(index: audioPlayer.playingIndex) {
            cell.activeAudioCell = false
        }
    }
    
    private func cellAtIndex(index: Int?) -> AudioClipCell? {
        guard let index = index else {
            print("Nil index.")
            return nil
        }
        
        guard let cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) else {
            print("Could not get cell at index \(index).")
            return nil
        }
        
        guard let audioCell = cell as? AudioClipCell else {
            print("Could convert cell \(cell) to audio clip cell at index \(index).")
            return nil
        }
        
        return audioCell
    }
    
    }

extension DiscoverBrowseViewController: AudioClipCellDelegate {
    func playButtonTapped(_ cell: AudioClipCell) {
        // Start playing audio at an index
        let audioPlayer = AudioPlayer.sharedInstance
        if let indexPath = collectionView?.indexPath(for: cell) {
            // Set the data source to this data source if it's not already
            if audioPlayer.dataSource !== dataSource {
                // Set the data source to this data soruce
                audioPlayer.dataSource = dataSource
            }
            
            // Check if it's the currently playing cell
            if indexPath.item == audioPlayer.playingIndex {
                audioPlayer.playing = !audioPlayer.playing // Toggle play/pause
                print(audioPlayer.playing ? "Played" : "Paused")
                print("protocol alpha")

            } else {
                //if
                audioPlayer.stop()

                print("protocol beta")
                let item = indexPath.item
                Allbeat.getTrackURL(trackID: trackIDS[item], completionBlock: { (url) in
                    audioPlayer.playAtIndex(index: item, url: url!) // Play the
                })
                //song at this index
                print("Played at index \(item)")
                /*} else {
                 print("Could not get item from index path \(indexPath)")
                 }*/
            }
        } else {
            print("Could not get index path of cell.")
        }
    }
    
    func likeButtonTapped(_ cell: AudioClipCell) {
        
        if (cell.likeButton.currentImage == #imageLiteral(resourceName: "LikeIcon")){
            cell.likeButton.setImage(#imageLiteral(resourceName: "UnlikedIcon"), for: .normal)
            Allbeat.like(userID: (FIRAuth.auth()?.currentUser?.uid)!,trackID: cell.trackIDCell) { (success: Bool) in
                //optional print statement
            }
            
        }
        else {
            cell.likeButton.setImage(#imageLiteral(resourceName: "LikeIcon"), for: .normal)
            Allbeat.unlike(userID: (FIRAuth.auth()?.currentUser?.uid)!,trackID: cell.trackIDCell) { (success: Bool) in
                //optional print statement
            }
        }
        
        
    }
    
    func shareButtonTapped(_ cell: AudioClipCell) {
        if (cell.shareButton.currentImage == #imageLiteral(resourceName: "ShareIcon")){
            cell.shareButton.setImage(#imageLiteral(resourceName: "Rebeated"), for: .normal)
            Allbeat.rebeat(userID: (FIRAuth.auth()?.currentUser?.uid)!,trackID: cell.trackIDCell) { (success: Bool) in
                //optional print statement
            }
            
        }
        else {
            cell.shareButton.setImage(#imageLiteral(resourceName: "ShareIcon"), for: .normal)
            Allbeat.unrebeat(userID: (FIRAuth.auth()?.currentUser?.uid)!,trackID: cell.trackIDCell) { (success: Bool) in
                //optional print statement
            }
        }
        
    }
    func commentsButtonTapped(_ cell: AudioClipCell) {
        globalTrackIDToPass = cell.trackIDCell
        performSegue(withIdentifier: "comment", sender: self)
        
    }
}
