//
//  CommentTableViewCell.swift
//  allbeat
//
//  Created by Ari on 8/24/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
