//
//  SearchTableViewController.swift
//  allbeat
//
//  Created by Ari on 8/21/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Foundation
import Firebase
class SearchTableViewController: UITableViewController, UITextFieldDelegate {
    // colors = [lightBlue, darkBlue, mediumBlue]
    @IBOutlet var search: UITextField!
    
    //useful variables
    var searched:Bool = true
    var filteredNames:[String] = []
    var tracks:[String] = []
    var users:[String] = []
    var iDs:[String: String] = [:]
    var point:Int?
    var point2:Int?
    var username:String?
    //example arrays
    var generas:[String] = ["rock", "rap | hip-hop", "reggae", "alternative", "pop", "jazz"]
    var generas2:[String] = ["rock channel", "rap | hip-hop channel", "reggae channel", "alternative channel", "pop channel", "jazz channel"]
    var examples:[String: UIImage] = [:]
    var dataUsers:[String: String] = [:]
    
    override func viewDidLoad() {
        
        self.search.layer.cornerRadius = 20.0
        self.search.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0 , 0)
        self.search.addTarget(self, action: #selector(SearchTableViewController.edited), for: UIControlEvents.editingChanged)
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(hex: 0x4A90E2)
        self.search.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.searched == false){
            self.tableView.separatorStyle = .none
            return self.generas.count
        }
        else{
            
            if (filteredNames.count == 0) {
                return 1
            }
            else {
                self.tableView.separatorStyle = .singleLine
                return self.filteredNames.count
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        // Configure the cell...
        var data: [String] = [] //data for cells
        cell.selectionStyle = .none
        //loads view from when user starts typing
        if (searched) {
            self.tableView.backgroundColor  = UIColor.white
            //error search view
            if filteredNames.count == 0 {
                cell.backgroundColor = UIColor.white
                cell.textLabel!.font = UIFont(name: "Raleway", size: 15)
                self.tableView.separatorStyle = .none
                cell.textLabel?.text = "Search for an artist, user, or song."
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor(hex: 0x4A90E2)
                data = self.filteredNames
                cell.selectionStyle = .none
                
                //cell.imageView!.image = #imageLiteral(resourceName: "untitledSong")
                cell.detail.text = ""
                cell.follow.isHidden = true
                
            }
                //search object view
            else{
                
                cell.follow.isHidden = true
                cell.textLabel?.text = ""
                cell.backgroundColor = UIColor.white
                data = self.filteredNames
                cell.followID = iDs[data[indexPath.row]]
                
            }
        }
        //start menu view
        
        //sets image and data in custom cell
        if(data.count != 0){
            cell.name.text = ""
            cell.imageView!.isHidden = false
            Allbeat.getTrackName(trackID: data[indexPath.row], completionBlock: { (name) in
                cell.name!.text = name
            })
            
            if(self.searched){
                
                //if user
                if (users.contains(data[indexPath.row])){
                    
                    cell.follow.isHidden = false
                    cell.followID = data[indexPath.row]
                    
                    Allbeat.getUserDisplayName(userID: data[indexPath.row], completionBlock: { (displayName) in
                        if(displayName != nil){
                            cell.detail.text = "@" + displayName!
                        }
                        else {
                            cell.detail.text = "no display name"
                        }
                    })
                    
                    Allbeat.getUserName(userID: data[indexPath.row], completionBlock: { (name) in
                        if(name != nil){
                            cell.name.text = name!
                        }
                        else {
                            cell.name.text = "no display name"
                        }
                    })

                        
                    Allbeat.getUserProPic(userID: data[indexPath.row]) { (art: String?) in
                        if (art != nil){
                            
                            //convert string to url
                            
                            let url = NSURL(string: art!)
                            
                            //convert url to image
                            
                            self.getDataFromUrl(url: url as! URL) { (data, response, error)  in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() { () -> Void in
                                    cell.picture.image = UIImage(data: data)
                                    
                                    
                                }
                            }
                        }
                        else {
                            
                            cell.picture.image = #imageLiteral(resourceName: "untitledHuman")
                            
                            
                        }
                        
                        
                    }

                }
            
                //if track
                    
                else {
                    
                    //ADD FOLLOW ARTIST --> NEEDS ABILITY TO GET ARTIST USERID
                
                    
                    Allbeat.getTrackArtist(trackID: data[indexPath.row], completionBlock: { (artist) in
                        if(artist != nil){
                            cell.detail.text = artist
                        }
                    })
                    
                    Allbeat.getTrackArt(trackID: data[indexPath.row]) { (art: String?) in
                        if (art != nil){
                            
                            //convert string to url
                            
                            let url = NSURL(string: art!)
                            
                            //convert url to image
                            
                            self.getDataFromUrl(url: url as! URL) { (data, response, error)  in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() { () -> Void in
                                    cell.picture.image = UIImage(data: data)
                                    
                                    
                                }
                            }
                        }
                        else {
                            
                            cell.picture.image = #imageLiteral(resourceName: "AppIconLaunchScreen")
                            
                            
                        }
                        
                        
                    }

                    
                }
                
                cell.imageView!.layer.masksToBounds = false
                cell.imageView!.layer.cornerRadius = 25.0
                cell.imageView!.layer.borderWidth = 1.0
                cell.imageView?.layer.borderColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/225.0), alpha: 1.0).cgColor
                cell.imageView!.clipsToBounds = true
                //cell.imageView!.image = #imageLiteral(resourceName: "untitledSong")
                cell.imageView!.isHidden = false
                
                
                cell.follow!.layer.cornerRadius = 15.0
                
                
                
            }
            
        }
        return cell
    }
    //search bar functions
    func edited() {
        self.filteredNames = []
        Allbeat.searchUsers(self.search.text!.lowercased()) { (users) in
            if(users != nil){
                self.filteredNames += users!
                self.users += users!
                self.tableView.reloadData()
            
            }
        }
        
        Allbeat.searchTracks(self.search.text!.lowercased()) { (tracks) in
            
            
            if(tracks != nil){
                self.filteredNames += tracks!
                self.tracks += tracks!
                self.tableView.reloadData()
            }
            
            
        }
        
        
    }
    
    func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filteredNames = []
        Allbeat.searchTracks(self.search.text!.lowercased()) { (tracks) in
            self.tracks = tracks!
            self.filteredNames = tracks!
            self.search.resignFirstResponder()
            self.tableView.reloadData()
            
        }
        
        
        
    }
    //used to get images from url's
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    
    //sets color for star menu tableview cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.username = self.filteredNames[indexPath.row]
        // if (indexPath.row < self.point2!){
        if (users.contains(self.filteredNames[indexPath.row])){
            self.performSegue(withIdentifier: "user", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "song", sender: self)

        }
        //}
        // else if (indexPath.row < self.point!){
        //self.performSegue(withIdentifier: "channel", sender: self)
        //  }
        //else {
        //    self.performSegue(withIdentifier: "song", sender: self)
        //  }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "user") {
            
            let UserProfileViewController = (segue.destination as! UserProfileViewController)
            UserProfileViewController.userID = self.username!
            
        }
        if(segue.identifier == "song") {
            
            let SongViewController = (segue.destination as! SongViewController)
            SongViewController.trackID = self.username!
            
        }
    }
    
    func getCellColor(index: Int) -> UIColor {
        let colors:[UIColor] = [UIColor.init(red: (161.0/255.0), green: (191.0/255.0), blue: (221.0/255.0), alpha: 1.0), UIColor(hex: 0x4A90E2), UIColor.init(red: (81.0/255.0), green: (115.0/255.0), blue: (147.0/255.0), alpha: 1.0)]
        
        if (index % 3 == 0) {
            return colors[0]
        }
        else if((index - 1) % 3 == 0){
            return colors[2]
        }
        else{
            return colors[1]
        }
    }
    //resizes image for table view
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    @IBAction func done(_ sender: AnyObject) {
        self.search.text = ""
        self.search.resignFirstResponder()
        self.tableView.reloadData()
    }
    //seperates users and albumns
    func seperate()  {
        var users:[String] = []
        var songs:[String] = []
        var channels:[String] = []
        for item in self.filteredNames {
            
            let first:String = self.dataUsers[item]!
            if(self.generas.contains(first)){
                users.append(item)
            }
            else if (self.generas2.contains(first)){
                channels.append(item)
            }
            else{
                songs.append(item)
            }
        }
        self.filteredNames = []
        self.filteredNames = users + channels + songs
        self.point2 = users.count
        self.point = users.count + channels.count
    }
    
}
