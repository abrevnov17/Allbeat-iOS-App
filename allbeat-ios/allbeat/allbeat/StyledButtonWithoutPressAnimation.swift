//
//  StyledButtonWithoutPressAnimation.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 8/30/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//


import UIKit

@IBDesignable class StyledButtonWithoutPressAnimation : UIControl {
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable var imagePadding: CGFloat = 12 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var roundedCorners: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var shadowed: Bool = false {
        didSet {
            // Shadow the button
            layer.shadowRadius = shadowed ? 15 : 0
            layer.shadowOpacity = shadowed ? 0.4 : 0
            layer.shadowOffset = CGSize.zero
        }
    }
    
    var background: UIColor = UIColor.init(colorLiteralRed: (0.0/255.0), green: (0.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    var tint: UIColor = UIColor.init(colorLiteralRed: (0.0/255.0), green: (0.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    
    private var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    func setup() {
        // Add an image view
        addSubview(imageView)
        
        // Save the background color
        background = backgroundColor ?? UIColor.white
        tint = tintColor ?? UIColor.white
        
        // Add the proper targets
        addTarget(self, action: #selector(press), for: UIControlEvents.touchDown)
        addTarget(self, action: #selector(depress), for: UIControlEvents(rawValue: UIControlEvents.touchUpInside.rawValue | UIControlEvents.touchUpOutside.rawValue))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Reposition the image
        imageView.frame.size = CGSize(width: bounds.width - imagePadding * 2, height: bounds.height - imagePadding * 2)
        imageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        // Update corner radius
        updateCornerRadius()
    }
    
    func press() {
        
}
    
    func depress() {
          }
    
    private func updateCornerRadius() {
        // Adjust the corners to the smallest side, if rounded corners are on
        if roundedCorners {
            layer.cornerRadius = min(bounds.height, bounds.width) / 2
        } else  {
            layer.cornerRadius = 0
        }
    }
}

