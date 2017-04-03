//
//  DiscoverBrowseViewController.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 8/28/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//
import UIKit

public class WaveformView : UIView {
    
    
    //sinewave frequency
    @IBInspectable public var frequency:CGFloat = 1.5
    
   
    //amplitude when amplitude is near 0
    @IBInspectable public var idleAmplitude:CGFloat = 0.01
    
    
    //change animation speed/direction
    @IBInspectable public var phaseShift:CGFloat = -0.15
    
    
    //how dense lines are
    @IBInspectable public var density:CGFloat = 1.0
    
    //thickness of lines for primary waves
    
    @IBInspectable public var primaryLineWidth:CGFloat = 1.5
    
    
    //line thickness for secondary waves
    @IBInspectable public var secondaryLineWidth:CGFloat = 0.5
    
    
    //number of waves total
    @IBInspectable public var numberOfWaves:Int = 6
    
    //wave color
    @IBInspectable public var waveColor:UIColor = UIColor.white
    
    
    //set the amplitude based on itself and the idleAmplitude
    @IBInspectable public var amplitude:CGFloat = 1.0 {
        didSet {
            amplitude = max(amplitude, self.idleAmplitude)
            self.setNeedsDisplay()
        }
    }
    
    private var phase:CGFloat = 0.0
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        // Convenience function to draw the wave
        func drawWave(index:Int, maxAmplitude:CGFloat, normedAmplitude:CGFloat) {
            let path = UIBezierPath()
            let mid = self.bounds.width/2.0
            
            path.lineWidth = index == 0 ? self.primaryLineWidth : self.secondaryLineWidth
            
            var x:CGFloat = 0
            while x < (self.bounds.width + self.density){
                // Parabolic scaling
                let scaling = -pow(1 / mid * (x - mid), 2) + 1
                let y = scaling * maxAmplitude * normedAmplitude * sin(CGFloat(2 * M_PI) * self.frequency * (x / self.bounds.width)  + self.phase) + self.bounds.height/2.0
                if x == 0 {
                    path.move(to: CGPoint(x:x, y:y))
                } else {
                    path.addLine(to: CGPoint(x:x, y:y))
                }
                x += self.density

            }

            path.stroke()
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        
        self.backgroundColor?.set()
        context?.fill(rect)
        
        let halfHeight = self.bounds.height / 2.0
        let maxAmplitude = halfHeight - self.primaryLineWidth
        
        for i in 0 ..< self.numberOfWaves {
            let progress = 1.0 - CGFloat(i) / CGFloat(self.numberOfWaves)
            let normedAmplitude = (1.5 * progress - 0.8) * self.amplitude
            let multiplier = min(1.0, (progress/3.0*2.0) + (1.0/3.0))
            self.waveColor.withAlphaComponent(multiplier * self.waveColor.cgColor.alpha).set()
            drawWave(index: i, maxAmplitude: maxAmplitude, normedAmplitude: normedAmplitude)
        }
        self.phase += self.phaseShift
    }
    
    
}
