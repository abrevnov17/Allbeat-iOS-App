//
//  DiscoverImageCell.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 8/28/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class DiscoverImageCell: UITableViewCell {
    
    //paralax stuff
    let imageParallaxFactor: CGFloat = 27
    var lastClicked: Int!
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgBackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBackBottomConstraint: NSLayoutConstraint!
    
    
    var model: DiscoverCellModel! {
        didSet {
            self.updateCellView()
        }
    }
    
    //basically this is just gonna work with constraints to orientate it properly
    func updateCellView() {
        self.imgBack.image = self.model.image
        self.lblTitle.text = self.model.title
        self.lblTitle.font=UIFont(name: "Raleway-Bold", size: 32)
    }
    
    func setBackgroundOffset(_ offset:CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1-boundOffset)*2*imageParallaxFactor
        self.imgBackTopConstraint.constant = self.imgBackTopInitial - pixelOffset
        self.imgBackBottomConstraint.constant = self.imgBackBottomInitial + pixelOffset
    }
    override func awakeFromNib() {
        self.clipsToBounds = true
        self.imgBackBottomConstraint.constant -= 2 * imageParallaxFactor
        self.imgBackTopInitial = self.imgBackTopConstraint.constant
        self.imgBackBottomInitial = self.imgBackBottomConstraint.constant
    }
    
    
    
}
