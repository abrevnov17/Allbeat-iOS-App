//
//  SearchTableViewCell.swift
//  allbeat
//
//  Created by Ari on 8/21/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var picture: UIImageView!
    var followID: String?
    @IBOutlet var follow: UIButton!
    @IBOutlet var detail: UILabel!
   

    @IBAction func follow(_ sender: AnyObject) {
        
    
        if (self.follow!.titleLabel!.text == "follow") {
            self.follow.setTitle("following", for: .normal)
            self.follow!.backgroundColor = UIColor.init(red: (184.0/255.0), green: (233.0/255.0), blue: (134.0/255.0) , alpha: 1.0)
            
            Allbeat.follow(userID: (Allbeat.getCurrentUser().uid), userID2: self.followID!, completionBlock: { (complete) in
                
            })
           
        }
        else{
            self.follow.setTitle("follow", for: .normal)
            self.follow!.backgroundColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/255.0) , alpha: 1.0)
            Allbeat.unfollow(userID: (Allbeat.getCurrentUser().uid), userID2: self.followID!, completionBlock: { (complete) in
                
            })
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   

}
