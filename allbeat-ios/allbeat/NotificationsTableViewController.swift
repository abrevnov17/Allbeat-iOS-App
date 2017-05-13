//
//  NotificationsTableViewController.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 9/17/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Foundation

class NotificationsTableViewController: UITableViewController, UITextFieldDelegate {
    
  
    //example arrays
    
    /*
    var albumIcon:[UIImage] = [#imageLiteral(resourceName: "angelalanisc"), #imageLiteral(resourceName: "aintnolovec"), #imageLiteral(resourceName: "4dic"), #imageLiteral(resourceName: "miamic"),#imageLiteral(resourceName: "mikec"),#imageLiteral(resourceName: "bluedotc"),#imageLiteral(resourceName: "bryandivisionsc")]
    var name: [String] = ["Ryan", "Bob","Jordan","Sam","James","Jim","Tammy"]
    var notificationDescription: [String] = ["rebeated", "liked","liked", "rebeated", "rebeated", "liked", "rebeated"]
    var time:[String]=["30s", "2m", "3h", "2d", "3d","4d", "11d"]
    */
    
    var albumIcon:[UIImage] = []
    var name: [String] = []
    var notificationDescription: [String] = []
    var time:[String]=[]

    @IBOutlet var noNotificationsLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(hex: 0x4A90E2)
        self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
        
        if (Allbeat.isLoggedIn() != true){
            self.performSegue(withIdentifier: "auth", sender: self)
        }
        
        //loading in notifications
        
        Allbeat.aggregateNotifications(userID: Allbeat.getCurrentUser().uid){ (notifications) in
            print("hello")
            print(notifications)
            for notification in notifications!{
                Allbeat.getNotification(userID: Allbeat.getCurrentUser().uid, notifID: notification){ (notif) in
                    let text = notif?["text"]
                    let timestamp = notif?["timestamp"]
                    let uid = notif?["uid"]
                    let trackid = notif?["trackid"]
                    
                    Allbeat.getUserProPic(userID: uid as! String) { (art: String?) in
                        if (art != nil){
                            
                            //convert string to url
                            
                            let url = NSURL(string: art!)
                            
                            //convert url to image
                            
                            self.getDataFromUrl(url: url as! URL) { (data, response, error)  in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() { () -> Void in
                                    self.albumIcon.append(UIImage(data: data)!)
                                }
                            }
                        }
                        else {
                            
                             self.albumIcon.append(#imageLiteral(resourceName: "untitledHuman"))
                            
                        }
                        
                        //self.notificationDescription.append(text as! String)
                        
                        Allbeat.getUserName(userID: uid as! String) { (username: String?) in
                            if (username != nil){
                                self.name.append(username!)
                                let replaced = (text as! NSString).replacingOccurrences(of: "null", with: username!)

                                self.notificationDescription.append(replaced)
                            }
                            
                            self.tableView.reloadData()

                            
                        }
                        self.tableView.reloadData()

                        //self.time.append(timestamp as! String)
                        
                    }

                }
            }
            
        }
        
        self.tableView.reloadData()

        

       
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
            if (name.count == 0) {
                return 1
            }
            else {
                self.tableView.separatorStyle = .singleLine
                return self.name.count
            }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTableViewCell
        // Configure the cell...
        cell.selectionStyle = .none
        //loads view from when user starts typing
        self.tableView.backgroundColor  = UIColor.white
            //error search view
            if name.count == 0 {
                cell.backgroundColor = UIColor.white
                cell.textLabel!.font = UIFont(name: "Raleway", size: 20)
                self.tableView.separatorStyle = .none
                cell.textLabel?.text = ""
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor(hex: 0x4A90E2)
                
                cell.imageView!.image = nil
                cell.detail.text = ""
                cell.time.isHidden = true
            }
                //search object view
            else{
                cell.textLabel?.text = ""
                cell.backgroundColor = UIColor.white
                
                
            }
        
        //start menu view
        
        //sets image and data in custom cell
        if(name.count != 0){
            //changing font size for top label in cell
            
            cell.name.font = cell.detail.font.withSize(15)
            cell.name.adjustsFontSizeToFitWidth = true
            
            cell.detail.text = self.name[indexPath.row]
            self.noNotificationsLabel.isHidden = true
            cell.imageView!.isHidden = true
            
            
                let image = ResizeImage(image: self.albumIcon[indexPath.row], targetSize: CGSize(width: 50, height: 50))
                cell.imageView!.layer.masksToBounds = false
                cell.imageView!.layer.cornerRadius = 25.0
                cell.imageView!.layer.borderWidth = 1.0
                cell.imageView?.layer.borderColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/225.0), alpha: 1.0).cgColor
                cell.imageView!.clipsToBounds = true
                cell.imageView!.image = image
                cell.imageView!.isHidden = false
                cell.name.text = self.notificationDescription[indexPath.row]
                //NEED TO UNCOMMENT BELOW FOR TIME
                //cell.time.text=self.time[indexPath.row]
                
            
            
        }
        //        if self.searched == false {
        //
        
        
        //        else{
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        //            OperationQueue.main.addOperation {
        //                cell.name!.text = self.generas[indexPath.row]
        //                print(self.generas[indexPath.row])
        //
        //            }
        //                        //cell.imageView = dataImages[indexPath.row]
        //            cell.textLabel?.textAlignment = .left
        //            cell.textLabel?.textColor = getCellColor(index: indexPath.row)
        //            cell.backgroundColor = UIColor.white
        //            return cell
        // 
        return cell
    }
    
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        if (indexPath.row < self.point2!){
            self.performSegue(withIdentifier: "user", sender: self)
        }
        else if (indexPath.row < self.point!){
            self.performSegue(withIdentifier: "channel", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "song", sender: self)
        }
 */
        
        
    }
 
    //used to get images from url's
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "user") {
            
            let profileViewController = (segue.destination as! ProfileViewController)
            profileViewController.edit = false
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
    
  
    
}

