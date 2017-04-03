//
//  UserTableViewCell.swift
//  allbeat
//
//  Created by Ari on 9/3/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!

    @IBOutlet var follow: UIButton!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var detail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func follow(_ sender: AnyObject) {
        if (self.follow!.titleLabel!.text == "follow") {
            self.follow.setTitle("following", for: .normal)
            self.follow!.backgroundColor = UIColor.init(red: (184.0/255.0), green: (233.0/255.0), blue: (134.0/255.0) , alpha: 1.0)
            
        }
        else{
            self.follow.setTitle("follow", for: .normal)
            self.follow!.backgroundColor = UIColor.init(red: (74.0/255.0), green: (144.0/255.0), blue: (226.0/255.0) , alpha: 1.0)
        }

    }

}
