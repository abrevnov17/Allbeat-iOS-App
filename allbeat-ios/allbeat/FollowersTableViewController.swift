//
//  FollowersTableViewController.swift
//  allbeat
//
//  Created by Ari on 9/3/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit
import Firebase

class FollowersTableViewController: UITableViewController {
    
    var userIDS:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.items?[0].image =  #imageLiteral(resourceName: "Home").withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[1].image = #imageLiteral(resourceName: "Disc").withRenderingMode(.alwaysOriginal)
        
        
        self.tabBarController?.tabBar.items?[2].image = #imageLiteral(resourceName: "Search").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[3].image = #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[4].image = #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //getting followers -> NEED TO ADD FUNCTIONALITY TO LOAD MORE PEOPLE
        
        Allbeat.getFollowers(userID: (FIRAuth.auth()?.currentUser?.uid)!, num: 50) { (followers) in
            
            self.userIDS = followers!
            
            self.tableView.reloadData()
            
        }
        
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
       return self.userIDS.count

    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        // Configure the cell...
        cell.selectionStyle = .none
        //loads view from when user starts typing
  
        //start menu view
        
        //sets image and data in custom cell
        
        Allbeat.getUserDisplayName(userID: userIDS[indexPath.item]) { (displayName) in
            
            cell.name.text = displayName!
            
        }
        
        Allbeat.getUserName(userID: userIDS[indexPath.item]) { (username) in
            
            cell.detail.text = "@" + username!
            
        }
        
        Allbeat.getUserProPic(userID: userIDS[indexPath.item]) { (url) in
            if (url != nil){
                //convert string to url
                
                let url = NSURL(string: url!)
                
                //convert url to image
                
                self.getDataFromUrl(url: url as! URL) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { () -> Void in
                        cell.imageView?.image = self.ResizeImage(image: UIImage(data : data)!, targetSize: CGSize(width: 50, height: 50))
                        
                        
                    }
                }
            }
            else{
                cell.imageView!.image = #imageLiteral(resourceName: "untitledHuman")
            }
        }

        
        cell.imageView!.layer.masksToBounds = false
        cell.imageView!.layer.cornerRadius = 25.0
        cell.imageView!.layer.borderWidth = 1.0
        cell.imageView?.layer.borderColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/225.0), alpha: 1.0).cgColor
        cell.imageView!.clipsToBounds = true
        cell.imageView!.isHidden = false
        cell.follow!.layer.cornerRadius = 15.0
        
        
        return cell
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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

