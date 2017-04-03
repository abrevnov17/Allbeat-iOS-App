import UIKit

class SongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var kbHeight: CGFloat!
    var songComments: [String] = []
    var data:[String] = ["id1", "id2", "id3"]
    var names:[String: String] = ["id1": "Luke Sywalker", "id2": "Princess Leia", "id3": "Han Solo"]
    var comments:[String: String] = ["id1": "Love this song!", "id2": "This is my jamjjkhkjhjkhkjhkjhkjhjkhjkhkjhjkhkjhkjhkjhkjhkjhkjhjkhkjhjkhkjhjkhjkhkjhjkhkjhjkhjkhjkhkjhjkhjhjkhkjlkjkljlkjkljlkjkjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj.", "id3": "I enjoy the chorus."]
    
    var times:[String: Date] = ["id1": Date(dateString:"2014-06-06"), "id2": Date(dateString:"2014-06-06"), "id3": Date(dateString:"2014-06-06")]
    var trackID:String = "-KUoYh3WAEU-87EctM__"
    var pendingRequest = false
    
    @IBOutlet var tableView: UITableView!
    // Indicates if reached the end of the items available
    var reachedEnd = false
    
    // Number of items to load at once
    var loadStep = 6
    //timer for waveform stuff
    var timer:Timer?
    
    var dataSource: PostDataSource?
    //change variable for waveform
    var change:CGFloat = 0.01
    
    var loadedItems = [BrowsingItem]()
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
    
    
    @IBOutlet var time: UILabel!
    @IBOutlet var comment: UITextView!
    @IBOutlet var rebeatLabel: UILabel!
    @IBOutlet var user: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBAction func comment(_ sender: AnyObject) {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SongViewController.reload), userInfo: nil, repeats: true)
        Allbeat.aggregateUserLikes(userID: (Allbeat.getCurrentUser().uid), num: 100) { (likes) in
            if (likes != nil){
            if (likes?.contains(self.trackID))!{
                 self.likeButton.setImage(#imageLiteral(resourceName: "likedBlue"), for: .normal)
            }
            }
        }
        Allbeat.aggregateUserRebeats(userID: (Allbeat.getCurrentUser().uid), num: 100) { (rebeats) in
            if (rebeats != nil){
            if (rebeats?.contains(self.trackID))!{
                self.shareButton.setImage(#imageLiteral(resourceName: "rebeatedBlue"), for: .normal)
            }
            else {
                self.shareButton.setImage(#imageLiteral(resourceName: "shareBlue"), for: .normal)
                }
            }
            
        }
        Allbeat.getTrackArt(trackID:trackID) { (art: String?) in
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
            else{
                self.albumArt.targetImage = #imageLiteral(resourceName: "AppIconLaunchScreen")
            }

        }
        
        //NEED A WAY TO GET ARTIST IMAGES
        
        self.artistPicture.image = #imageLiteral(resourceName: "untitledHuman")
        
    }
    func reload() {
        self.tableView.reloadData()
        
        Allbeat.aggregateComments(trackID: self.trackID, num: 100) { (comments) in
            print("com", comments?.count)
            if(comments != nil){
            if ((comments?.count)! > 0){
                print(comments)
                self.songComments = comments!
                self.tableView.reloadData()
                print("comments" + self.songComments[0])
                
            }
            }
        }
        if (self.songComments.count > 0){
            let oldLastCellIndexPath = IndexPath(row: self.songComments.count-1, section: 0)
            self.tableView.scrollToRow(at: oldLastCellIndexPath, at: .bottom, animated: false)
        }
        Allbeat.getNumTrackLikes(trackID: self.trackID) { (likes) in
            if (likes == nil){
                self.likesLabel.text = "0"
                
            }
            else {
                let num:Int = likes!
                self.likesLabel.text = String(describing: num)
            }
            
        }
        Allbeat.getNumRebeats(trackID: self.trackID) { (rebeats) in
            if (rebeats == nil){
                
                self.rebeatLabel.text = "0"
                
            }
            else {
                let num:Int = rebeats!
                self.rebeatLabel.text = String(describing: num)
            }
        }

    }
    @IBAction func like(_ sender: AnyObject) {
       
       
        if (self.likeButton.currentImage == #imageLiteral(resourceName: "likeBlue")){
            self.likeButton.setImage(#imageLiteral(resourceName: "likedBlue"), for: .normal)
            Allbeat.like(userID: (Allbeat.getCurrentUser().uid), trackID: self.trackID) { (complete) in
                
                print("liked: ", complete)
                if (complete){
                Allbeat.getNumTrackLikes(trackID: self.trackID) { (likes) in
                    if(likes != nil){
                        self.likesLabel.text = String(describing: likes!)
                        print("likes", likes)
                        
                    }
                }
                }
            }
            
        }
        else {
            self.likeButton.setImage(#imageLiteral(resourceName: "likeBlue"), for: .normal)
            Allbeat.unlike(userID: (Allbeat.getCurrentUser().uid), trackID: trackID, completionBlock: { (complete) in
                print("unliked: ", complete)
                if (complete){
                Allbeat.getNumTrackLikes(trackID: self.trackID) { (likes) in
                    if(likes != nil){
                        self.likesLabel.text = String(describing: likes!)
                        print("likes", likes)
                        
                    }
                    }
                }
            })
            }
        
        
       
       
        
    }
    @IBAction func rebeat(_ sender: AnyObject) {
        if (self.shareButton.currentImage == #imageLiteral(resourceName: "shareBlue")){
            self.shareButton.setImage(#imageLiteral(resourceName: "rebeatedBlue"), for: .normal)
            Allbeat.rebeat(userID: (Allbeat.getCurrentUser().uid), trackID: self.trackID, completionBlock: { (complete) in
                if (complete){
                    self.shareButton.setImage(#imageLiteral(resourceName: "rebeatedBlue"), for: .normal)
                }
            })
            
        }
        else {
            Allbeat.unrebeat(userID: (Allbeat.getCurrentUser().uid), trackID: self.trackID, completionBlock: { (complete) in
                if (complete){
                     self.shareButton.setImage(#imageLiteral(resourceName: "shareBlue"), for: .normal)
                }
            })
            
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
    
    @IBAction func playTappedmoreFun(_ sender: AnyObject) {
        let audioPlayer = AudioPlayer.sharedInstance
        if audioPlayer.dataSource !== dataSource {
            // Set the data source to this data soruce
            audioPlayer.dataSource = dataSource
        }
        
        // Check if it's the currently playing cell
        if 0 == audioPlayer.playingIndex {
            audioPlayer.playing = !audioPlayer.playing // Toggle play/pause
            print(audioPlayer.playing ? "Played" : "Paused")
        } else {
            
            Allbeat.getTrackURL(trackID: self.trackID, completionBlock: { (url) in
                audioPlayer.playAtIndex(index: 0, url: url!)
            })
            /*} else {
             print("Could not get item from index path \(indexPath)")
             }*/
        }
        progressView.progress = progress
    }
    @IBAction func playTapped(_ sender: AnyObject) {
        let audioPlayer = AudioPlayer.sharedInstance
        if audioPlayer.dataSource !== dataSource {
            // Set the data source to this data soruce
            audioPlayer.dataSource = dataSource
        }
        
        // Check if it's the currently playing cell
        if 0 == audioPlayer.playingIndex {
            audioPlayer.playing = !audioPlayer.playing // Toggle play/pause
            print(audioPlayer.playing ? "Played" : "Paused")
        } else {
            
            let item = 0
            Allbeat.getTrackURL(trackID: self.trackID, completionBlock: { (url) in
                audioPlayer.playAtIndex(index: 0, url: url!) // Play the song at this index
                print("Played at index \(item)")
            })
            
            /*} else {
             print("Could not get item from index path \(indexPath)")
             }*/
        }
        progressView.progress = progress
    }
    
    @IBAction func platappedfun(_ sender: AnyObject) {
        let audioPlayer = AudioPlayer.sharedInstance
        if audioPlayer.dataSource !== dataSource {
            // Set the data source to this data soruce
            audioPlayer.dataSource = dataSource
        }
        
        // Check if it's the currently playing cell
        if 0 == audioPlayer.playingIndex {
            audioPlayer.playing = !audioPlayer.playing // Toggle play/pause
            print(audioPlayer.playing ? "Played" : "Paused")
        } else {
            
            let item = 0
            Allbeat.getTrackURL(trackID: self.trackID, completionBlock: { (url) in
                audioPlayer.playAtIndex(index: 0, url: url!)
            })
       // Play the song at this index
            print("Played at index \(item)")
            /*} else {
             print("Could not get item from index path \(indexPath)")
             }*/
        }
        progressView.progress = progress
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
    
    @IBOutlet weak var albumArt: ParralaxImageView!
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var artistPicture: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var playButton: StyledButtonWithoutPressAnimation!
    @IBOutlet weak var progressView: AudioProgressView!
    
    // The display link
    var displayLink: CADisplayLink!
    override func viewDidLoad(){
        super.viewDidLoad()
        //self.trackID = "-KUoYh3WAEU-87EctM__"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        progressView.isHidden = false
        self.dataSource = PostDataSource(source: .feed)
        loadMoreItems()
        setup()
        // self.likesLabel.text = "103"
        // self.user.text = "wild fantasy"
        // self.comment.text = "our latest song in our upcoming album, Oceanrider!"
        ///self.time.text = "17m"
        Allbeat.getTrackArtist(trackID: self.trackID) { (artist) in
            self.artistName.text = artist
        }
        Allbeat.getTrackURL(trackID: self.trackID) { (url) in
            
        }
        Allbeat.getTrackName(trackID: self.trackID) { (track) in
             self.songTitle.text = track
        }
        Allbeat.getTrackGenre(trackID: self.trackID) { (genere) in
            self.descriptionLabel.text = genere
        }
        
        switch loadedItems[0] {
        case .user(_):
        break // TODO: Add support for this
        case .post(let data):
            
            
            // Set the data
            setData(data, index: 0)
            
            // Set as the delegate
            
            
            // Tell it it's playing if it's the current playign index
            if 0 == AudioPlayer.sharedInstance.playingIndex {
                self.activeAudioCell = true
                self.playing = AudioPlayer.sharedInstance.playing
            } else {
                self.activeAudioCell = false
            }
            
            
        case .comment(_):
            break // TODO: Add support for this
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SongViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //   NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                kbHeight = keyboardSize.height
                self.animateTextField(up: true)
            }
        }
    }
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement!)
        })
    }
    
    func loadMoreItems() {
        // Notify if delegate is nil
        if dataSource == nil { print("Delegate is nil") }
        
        
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
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        
        //change waveform properties
        
        // waveformView.amplitude = 1.0
        
        
        // Add a run loop
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
        displayLink.isPaused = true
        
    }
    
    func setData(_ data: PostData, index: Int) {
        // Reset the progress
        progress = 0
        waveformView.density = 0.1
        waveformView.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AudioClipCell.refreshAudioView(_:)), userInfo: nil, repeats: true)
        
        
        // Assign the album art
        //		albumArt.image = data.albumArt // TODO: Album art
        //albumArt.targetImage = #imageLiteral(resourceName: "All We Know")
        Allbeat.getNumTrackLikes(trackID: self.trackID) { (likes) in
            if (likes == nil){
                self.likesLabel.text = "0"

            }
            else {
                let num:Int = likes!
                self.likesLabel.text = String(describing: num)
            }
            
        }
        Allbeat.getNumRebeats(trackID: self.trackID) { (rebeats) in
            if (rebeats == nil){
                
                self.rebeatLabel.text = "0"
                
            }
            else {
                let num:Int = rebeats!
                self.rebeatLabel.text = String(describing: num)
            }
        }
        
        // Set the text data
        songTitle.text = data.title
      
        //		artistName.text = data.artist // TODO: Artist name
        //		artistPicture.image = data. // TODO: Artist picture
        //artistPicture.image = #imageLiteral(resourceName: "The Chainsmokers")
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
        
        
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.songComments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell

        if self.songComments.count > 0 {
            //COME BACK TO IMPLEMENT
           // Allbeat.getCommentUser(trackID: self.trackID!, commentID: self.songComments[indexPath.row] , completionBlock: { (result) in
               // print("hi", result!)
              //  Allbeat.getUserName(user:  result!, completionBlock: { (person) in
               //     print("hi", person!)
                  //  cell.name.text = person!
                //})
                //Allbeat.getComment(trackID: self.trackID!, commentID: self.songComments[indexPath.row], completionBlock: { (text) in
                //    cell.comment.text = text
              //  })
                
               // Allbeat.getCommentTime(trackID: self.trackID!, commentID: self.songComments[indexPath.row], completionBlock: { (stamp) in
                //    let date = Date(timeIntervalSince1970: stamp!)
                 //   cell.time.text = "0 d"
              //  })
                
                
                
                // cell.time.text = self.getDate(date: self.times[self.data[indexPath.row]]!)
                
          //  })
            // Allbeat.getCommentUser(trackID: self.trackID, commentID: self.songComments[indexPath.row]) { (result) in
            //  user = result
            //}
            // Allbeat.getComment(trackID: self.trackID, commentID: self.songComments[0]) { (result) in
            //   comment = result
            //  }
            
            
            
            
            // Configure the cell...
            //self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
        return cell
    }
    func getDate(date: Date) -> String {
        var finalString:String
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let monthInt = (calendar?.component(NSCalendar.Unit.month, from: date))!
        let yearInt = (calendar?.component(NSCalendar.Unit.year, from: date))!
        let minuteInt = (calendar?.component(NSCalendar.Unit.minute, from: date))!
        let dayInt = (calendar?.component(NSCalendar.Unit.day, from: date))!
        let secondInt = (calendar?.component(NSCalendar.Unit.second, from: date))!
        let hourInt = (calendar?.component(NSCalendar.Unit.hour, from: date))!
        
        let monthIntNow = (calendar?.component(NSCalendar.Unit.month, from: Date()))!
        let yearIntNow = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        let minuteIntNow = (calendar?.component(NSCalendar.Unit.minute, from: Date()))!
        let dayIntNow = (calendar?.component(NSCalendar.Unit.day, from: Date()))!
        let hourIntNow = (calendar?.component(NSCalendar.Unit.hour, from: Date()))!
        let secondIntNow = (calendar?.component(NSCalendar.Unit.second, from: Date()))!
        if (yearIntNow - yearInt == 0){
            if (monthIntNow - monthInt == 0){
                if (dayIntNow - dayInt == 0){
                    if (hourIntNow - hourInt == 0) {
                        if (minuteIntNow - minuteInt == 0){
                            finalString = String(secondIntNow - secondInt) + " sec"
                            return finalString
                            
                        }
                        else {
                            finalString = String(minuteIntNow - minuteInt) + " min"
                            return finalString
                        }
                    }
                    else {
                        finalString = String(hourIntNow-hourInt) + " hr"
                        return finalString
                    }
                    
                }
                else {
                    finalString = String(dayIntNow-dayInt) + " d"
                    return finalString
                }
                
            }
            else {
                finalString = String(monthIntNow-monthInt) + " mo"
                return finalString
            }
        }
        else {
            finalString = String(yearIntNow-yearInt) + " yr"
            return finalString
        }
        
    }
    //used to get images from url's
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "comment"){
            let commentControler = CommentViewController()
            commentControler.trackID = self.trackID
        }
    }
    
    @IBAction func commentAction(_ sender: AnyObject) {
       self.performSegue(withIdentifier: "comment", sender: self)
    }
    
    func updateProgress() {
        if let percentComplete = AudioPlayer.sharedInstance.percentComplete {
            progress = CGFloat(percentComplete)
        } else {
            print("Could not get percent complete.")
        }
        
    }
}
