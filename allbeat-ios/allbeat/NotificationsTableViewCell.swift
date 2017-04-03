//
//  NotificationsTableViewCell.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 9/17/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var picture: UIImageView!
    
    @IBOutlet var time: UILabel!
    @IBOutlet var detail: UILabel!
    
    
    @IBAction func clickedNotifications(_ sender: AnyObject) {
        
        //idk if we wanna do something after being pressed
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}

