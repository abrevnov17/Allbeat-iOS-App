//
//  ProfileViewController.swift
//  allbeat
//
//  Created by Ari on 8/28/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Firebase
class ChannelViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var edit:Bool = true
    var name:String = ""
    @IBOutlet var editProfile: UIButton?
    @IBOutlet var ArtistName: UILabel!
    @IBOutlet var profileView: UIImageView!
    
    @IBOutlet var noPosts: UILabel!
    @IBOutlet var rebeatName: UILabel!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var bio: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var seg: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    private let audioClipCellId = "AudioClip"
    var channelName: String?
    // The delegate
    var dataSource: PostDataSource?
    
    // The array of loaded items
    var loadedItems = [BrowsingItem]()
    
    // If there is a pending request
    var pendingRequest = false
    
    // Indicates if reached the end of the items available
    var reachedEnd = false
    
    // Number of items to load at once
    var loadStep = 6
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView.isHidden = true
        self.noPosts.isHidden = false
        
        self.tabBarController?.tabBar.items?[0].image =  #imageLiteral(resourceName: "Home").withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[1].image = #imageLiteral(resourceName: "Disc").withRenderingMode(.alwaysOriginal)
        
        
        self.tabBarController?.tabBar.items?[2].image = #imageLiteral(resourceName: "Search").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[3].image = #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[4].image = #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal)
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
        // TEMP: Load delegate count into loadStep
        dataSource = PostDataSource(source: .feed)
        
        // Update the cell size
        updateCellSize()
        
        // Load a initial items
        loadMoreItems()
        self.editProfile?.layer.cornerRadius = 15.0
        self.profileView.layer.cornerRadius = 40.0
        self.profileView.layer.borderWidth = 1.0
        self.profileView.layer.borderColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/225.0), alpha: 1.0).cgColor
        self.profileView.clipsToBounds = true
        self.profileView.sizeToFit()
        self.username.text = self.name + "channel"
        self.bio.text = "The latest up and comming " + self.name + "."
        self.ArtistName.text = self.name
        self.profileView.image = UIImage(named: self.name)
        
    }
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedItems.count
    }
    
    @IBAction func `let`(_ sender: AnyObject) {
        self.collectionView.reloadData()
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //guard
        let item = indexPath.item /*else {
         print("Could not get item from index path \(indexPath).")
         return UICollectionViewCell()
         }*/
        
        switch loadedItems[item] {
        case .user(_):
        break // TODO: Add support for this
        case .post(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioClip", for: indexPath as IndexPath) as! AudioClipCell
            
            if (self.seg?.selectedSegmentIndex == 1){
                cell.rebeatedIcon?.isHidden = true
                cell.rebeatName?.isHidden = true
            }
            else {
                cell.rebeatedIcon?.isHidden = false
                cell.rebeatName?.isHidden = false
            }
            
            // Set the data
            cell.setData(data, index: item, trackID: "-KUoYh3WAEU-87EctM__")
            
            // Set as the delegate
            cell.delegate = self
            
            // Tell it it's playing if it's the current playign index
            if item == AudioPlayer.sharedInstance.playingIndex {
                cell.activeAudioCell = true
                cell.playing = AudioPlayer.sharedInstance.playing
            } else {
                cell.activeAudioCell = false
            }
            
            return cell
        case .comment(_):
            break // TODO: Add support for this
        }
        
        // TEMP: This is temporary
        print("INVALID CELL")
        return UICollectionViewCell()
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    func updateCellSize(_ screenSize: CGSize? = nil) {
        let screenSize = screenSize ?? view.bounds.size
        
        // Scales the cells to snap to widths
        let minWidth: CGFloat = 300
        var width = screenSize.width
        width /= max(floor(width / minWidth), 1)
        
        // Assign the size
        (self.collectionView.collectionViewLayout as? BrowseCollectionViewFlowLayout)?.itemSize = CGSize(width: width, height: floor(width * 0.75))
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Load more items
        if indexPath.item == loadedItems.count - 1 && !reachedEnd {
            //			loadMoreItems()
        }
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
        if (self.edit == false){
            self.editProfile!.isHidden = true
        }
        // Register as a delegate
        AudioPlayer.sharedInstance.delegates.register(self)
        let user1 = Allbeat.getCurrentUser()
        //self.username.text = self.channelName
        //self.userImg.image = UIImage(named:self.channelName!)
       
        
        
        
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
    
}



extension ChannelViewController: AudioClipCellDelegate {
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
            } else {
                //if
                let item = indexPath.item
                Allbeat.getTrackURL(trackID: "-KUoYh3WAEU-87EctM__", completionBlock: { (url) in
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
            
            
        }
        else {
            cell.likeButton.setImage(#imageLiteral(resourceName: "LikeIcon"), for: .normal)
        }
    }
    
    func shareButtonTapped(_ cell: AudioClipCell) {
        if (cell.shareButton.currentImage == #imageLiteral(resourceName: "ShareIcon")){
            cell.shareButton.setImage(#imageLiteral(resourceName: "Rebeated"), for: .normal)
            
            
        }
        else {
            cell.shareButton.setImage(#imageLiteral(resourceName: "ShareIcon"), for: .normal)
        }
        
    }
    
    func commentsButtonTapped(_ cell: AudioClipCell) {
        performSegue(withIdentifier: "comment", sender: self)
        
    }
}

extension ChannelViewController: AudioPlayerDelegate {
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
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


