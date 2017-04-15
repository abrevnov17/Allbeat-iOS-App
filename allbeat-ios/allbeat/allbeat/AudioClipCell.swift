//
//  AudioClipCell.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/13/15. Modified by Anatoly Brevnov on 8/29/16.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit
import  Firebase
protocol AudioClipCellDelegate: class {
    func playButtonTapped(_ cell: AudioClipCell)
    func likeButtonTapped(_ cell: AudioClipCell)
    func shareButtonTapped(_ cell: AudioClipCell)
    func commentsButtonTapped(_ cell: AudioClipCell)
}

class AudioClipCell: UICollectionViewCell {
    
    //timer for waveform stuff
    var timer:Timer?
    //change variable for waveform
    var change:CGFloat = 0.01
    //trackID variable (necessary for liking and stuff
    var trackIDCell = ""
    
    
    // The progress through the song, between [0, 1]
    var progress: CGFloat = 0 {
        didSet {
            if progress == 0 {
                progressView.isHidden = true
                progressView.progress = 0
            } else {
                progressView.isHidden = false
                progressView.progress = progress
            }
        }
    }
    
    
    internal func refreshAudioView(_:Timer) {
        if (!playButton.isTouchInside)
        {
            self.waveformView.isHidden = true;
        }
            
        else if (AudioPlayer.sharedInstance.playing) {
            
            self.waveformView.isHidden = false
            self.waveformView.amplitude += self.change
            
            if self.waveformView.amplitude <= self.waveformView.idleAmplitude || self.waveformView.amplitude > 1.0 {
                self.change *= -1.0
            }
            
        }
        else {
            self.waveformView.isHidden = true;
            
        }
        
        
    }
    
    
    // Determinds if playing or paused
    var playing: Bool = false {
        didSet {
            // Updates the state of the play butotn
            playButton.image = nil
            playButton.backgroundColor = UIColor.clear
        }
    }
    
    // Determinds if this is the active audio cell
    var activeAudioCell: Bool = false {
        didSet {
            // Set the display link to active or not appropriately
            displayLink.isPaused = !activeAudioCell
            
            // Setup the run loop
            progressView.isActive = activeAudioCell
            if !activeAudioCell {
                playing = false
                progress = 0
            }
        }
    }
    
    // The display link to update the
    
    // Image icons
    private static let playIcon = UIImage(named: "PlayIcon"), pauseIcon = UIImage(named: "PauseIcon")
    
    // Cell delegate
    weak var delegate: AudioClipCellDelegate?
    
    
    // Views
    
    
    //waveform view
    @IBOutlet weak var waveformView: WaveformView!
    
    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var rebeatNumber: UILabel!
    
    @IBOutlet var rebeatedIcon: UIImageView!
    @IBOutlet var rebeatName: UILabel!
    @IBOutlet weak var albumArt: ParralaxImageView!
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var artistPicture: RoundedImageView!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var playButton: StyledButtonWithoutPressAnimation!
    @IBOutlet weak var progressView: AudioProgressView!
    
    // The display link
    var displayLink: CADisplayLink!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        
        //change waveform properties
        
        // waveformView.amplitude = 1.0
        
        
        // Add a run loop
        print("nine")
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
        displayLink.isPaused = true
        
    }
    
    func setData(_ data: PostData, index: Int, trackID:String) {
        
        //unhide the following once you can see which one of the people you are following rebeated it
        rebeatName.isHidden = true
        rebeatedIcon.isHidden = true
        
        let user = FIRAuth.auth()?.currentUser?.uid
        
        if (user != nil){
            trackIDCell = trackID
            Allbeat.getTrackArt(trackID: trackID) { (art: String?) in
                if (art != nil){
                    
                    //convert string to url
                    
                    let url = NSURL(string: art!)
                    
                    //convert url to image
                    
                    self.getDataFromUrl(url: url as! URL) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async() { () -> Void in
                            self.albumArt.targetImage = UIImage(data: data)
                        }
                    }
                }
                else {
                    
                    self.albumArt.targetImage = #imageLiteral(resourceName: "AppIconLaunchScreen")
                
                }
                
                
            }
            
            //NEED WAY TO GET ARTIST IMAGE
            
            Allbeat.getArtistArt(trackID: trackID) { (art: String?) in
                if (art != nil){
                    
                    //convert string to url
                    
                    let url = NSURL(string: art!)
                    
                    //convert url to image
                    
                    self.getDataFromUrl(url: url as! URL) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async() { () -> Void in
                            self.artistPicture.targetImage = UIImage(data: data)
                        }
                    }
                }
                else {
                    
                    self.artistPicture.targetImage = #imageLiteral(resourceName: "untitledHuman")
                    
                }
                
                
            }

            

            
            
            //you should do num rebeats and num likes for each thing
            
           
            Allbeat.getTrackArtist(trackID: trackID) { (artist) in
                self.artistName.text = artist
            }
            Allbeat.getTrackGenre(trackID: trackID) { (genre) in
                self.descriptionLabel.text = genre
            }
            
            Allbeat.getTrackName(trackID: trackID) { (name) in
                self.songTitle.text = name
                
            }
            
            Allbeat.getNumTrackLikes(trackID: trackID) { (num) in
                if (num != nil){
                    print("alphaOrange",num!)
                    self.likeNumber.text = String(describing: num!)
                }
                else {
                    self.likeNumber.text = "0"
                    
                }
            }
            
            Allbeat.getNumRebeats(trackID: trackID) { (num) in
                if (num != nil){
                    self.rebeatNumber.text = String(describing: num!)
                }
                else {
                    self.rebeatNumber.text = "0"

                }
            }
            
            
            Allbeat.hasUserRebeated(userID: user!, trackID: trackID) { (success) in
                
                if (success)!{
                    self.shareButton.setImage(#imageLiteral(resourceName: "Rebeated"), for: .normal)
                }
                
                else {
                    
                    self.shareButton.setImage(#imageLiteral(resourceName: "ShareIcon"), for: .normal)

                }
                
            }
            
            Allbeat.hasUserLiked(userID: user!, trackID: trackID) { (success) in
                
                if (success)!{
                    self.likeButton.setImage(#imageLiteral(resourceName: "LikeIcon"), for: .normal)
                }
                    
                else {
                    
                    self.likeButton.setImage(#imageLiteral(resourceName: "UnlikedIcon"), for: .normal)
                    
                }
                
            }
        }
        // Reset the progress
        progress = 0
        waveformView.density = 0.1
        waveformView.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AudioClipCell.refreshAudioView(_:)), userInfo: nil, repeats: true)
        
        
        // Assign the album art
        //		albumArt.image = data.albumArt // TODO: Album art
        
        
        // Set the text data
        songTitle.text = data.title
        //		artistName.text = data.artist // TODO: Artist name
        //		artistPicture.image = data. // TODO: Artist picture
        
        artistPicture.layer.masksToBounds = true
        artistPicture.layer.cornerRadius = 28.0
        artistPicture.layer.borderWidth = 1.0
        artistPicture.layer.borderColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/225.0), alpha: 1.0).cgColor
        waveformView.backgroundColor=UIColor.clear
        
        // Reset play button
        playing = false
        
        waveformView.amplitude=1.2
        
        //hiding old format
        //playButton.isHidden = true
        playButton.image=nil
        //progressView.isHidden = true
        playButton.backgroundColor = UIColor.clear
        
        self.bringSubview(toFront: commentButton)
        self.bringSubview(toFront: likeButton)
        self.bringSubview(toFront: shareButton)
        
        
        
        
        
    }
    
    
    func updateProgress() {
        if let percentComplete = AudioPlayer.sharedInstance.percentComplete {
            progress = CGFloat(percentComplete)
        } else {
            print("Could not get percent complete.")
        }
        
    }
    
    //used to get images from url's
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    
}

extension AudioClipCell {
    @IBAction func goComment(_ sender: AnyObject) {
            
    }
    
    
    @IBAction func goLike(_ sender: AnyObject) {
    }
    @IBAction func playTapped(_ sender: StyledButtonWithoutPressAnimation) {
        delegate?.playButtonTapped(self)
    }
    @IBAction func playReleased(_ sender: StyledButtonWithoutPressAnimation) {
        if (AudioPlayer.sharedInstance.playing){
            delegate?.playButtonTapped(self)
        }
    }
    
    @IBAction func likeTapped(_ sender: AnyObject) {
        delegate?.likeButtonTapped(self)
    }
    @IBAction func commentTapped(_ sender: AnyObject) {
        delegate?.commentsButtonTapped(self)
    }
    @IBAction func shareTapped(_ sender: AnyObject) {
        delegate?.shareButtonTapped(self)
    }
    
    
    
}


