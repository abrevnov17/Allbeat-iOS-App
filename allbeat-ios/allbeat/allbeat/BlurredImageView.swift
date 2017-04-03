//
//  BlurredImageView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/13/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//
//
//import UIKit
//import GPUImage
//
//class BlurredImageView: UIView {
//	// The image to blur
//	var targetImage: UIImage? {
//		didSet {
//			// Generate the blurred image
//			generateBlurredImage()
//			// layer.contents = targetImage?.CGImage // DEBUG
//		}
//	}
//	
//	// The cached image that was blurred
//	private var blurredImage: UIImage?
//	
//	// Queue for blurring operations
//	private var queue = OperationQueue()
//	
//	// Returns a center position on the global coordinate scale
//	private var globalCenter: CGPoint {
//		return convert(center, to: nil)
//	}
//	
//	// Link to getting updates every frame
//	private var displayLink: CADisplayLink!
//	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		
//		setup()
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		
//		setup()
//	}
//	
//	func setup() {
//		// Set up the queue
//		queue.maxConcurrentOperationCount = 1
//		
//		// Set up the display link
//		displayLink = CADisplayLink(target: self, selector: #selector(BlurredImageView.update))
//		displayLink.add(to: RunLoop.main(), forMode: RunLoopMode.commonModes.rawValue)
//		
//		// Setup the view
//		backgroundColor = UIColor.darkGray()
//	}
//	
//	// Called once a frame to update teh look
//	func update() {
//		// Change the image offset based on the global position
//		if let _ = targetImage where layer.contents != nil {
//			// Fit the bounds to the image square
//			var newContentsRect = layer.bounds.aspectFitRect(CGRect(x: 0, y: 0, width: 1, height: 1))
//			
//			// Move the content rect to reflect its amount of way down the screen
//			let t = globalCenter.y / UIScreen.main().bounds.height
//			newContentsRect.origin.y = t * (1 - newContentsRect.height)
//			
//			// Fit the bounds to the image square
//			if layer.contentsRect != newContentsRect {
//				layer.contentsRect = newContentsRect
//			}
//		}
//	}
//	
//	// Called when new blur needs generating
//	private func generateBlurredImage() {
//		if let _ = targetImage {
//			// Cancel all current blurring operations
//			queue.cancelAllOperations()
//			
//			// Add a new blurring operation
//			queue.addOperation(ImageBlurringOperation(imageView: self))
//		} else {
//			// Remove the image
//			self.layer.contents = nil
//		}
//	}
//	
//	deinit {
//		// Remove the display link
//		displayLink.invalidate()
//	}
//}
//
//class ImageBlurringOperation: Operation {
//	private var imageView: BlurredImageView
//	
//	init(imageView: BlurredImageView) {
//		self.imageView = imageView
//	}
//	
//	override func main() {
//		// Check cancelled
//		self.isCancelled
//		
//		if let targetImage = imageView.targetImage {
//			// Create group for the filters
//			let filterGroup = GPUImageFilterGroup()
//			
//			// Create blur filter
//			let blurFilter = GPUImageiOSBlurFilter()
//			blurFilter.blurRadiusInPixels = 8
//			blurFilter.downsampling = 8
//			
//			// Create brightness filter
//			let brightnessFilter = GPUImageBrightnessFilter()
//			brightnessFilter.brightness = -0.08
//			blurFilter.addTarget(brightnessFilter)
//			
//			// Register the filters
//			filterGroup.addFilter(blurFilter)
//			filterGroup.addFilter(brightnessFilter)
//
//			filterGroup.initialFilters = [ blurFilter ]
//			filterGroup.terminalFilter = brightnessFilter
//			
//			// Generate the final image
//			let finalImage: UIImage = filterGroup.imageByFilteringImage(targetImage)
//			
//			// Check cancelled
//			self.isCancelled
//			
//			// Assign the image on the main thread
//			OperationQueue.main().addOperation
//				{
//					// Assign the image
//					self.imageView.layer.contents = finalImage.cgImage
//				}
//		}
//	}
//}
