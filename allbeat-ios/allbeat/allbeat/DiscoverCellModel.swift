//
//  DiscoverCellModel.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 8/28/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import Foundation
import UIKit

class DiscoverCellModel {
    
    //heres our model
    
    //title
    var title: String
    //nameOfImage
    var image: UIImage
    
    init(title:String, image:UIImage) {
        //basic constructor
        self.title = title
        self.image = image
    }
    
}
