//
//  FormCollectionView.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/9/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class FormCollectionViewFlowLayout: UICollectionViewFlowLayout {
//	var indexPathsToAnimate = [NSIndexPath]()
//	
//	override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//		let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)!
//		
//		if indexPathsToAnimate.contains(itemIndexPath) {
//			attributes.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), CGFloat(M_PI))
//			attributes.center = CGPoint(x: CGRectGetMinX(collectionView!.bounds), y: CGRectGetMinY(collectionView!.bounds))
//			indexPathsToAnimate.removeObject(itemIndexPath)
//		}
//		
//		return attributes
//	}
//	
//	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//		if collectionView!.bounds == newBounds {
//			return true
//		}
//		return false
//	}
//	
//	override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
//		super.prepareForCollectionViewUpdates(updateItems)
//		
//		for updateItem in updateItems {
//			switch updateItem.updateAction {
//			case .Insert:
//				indexPathsToAnimate += [ updateItem.indexPathAfterUpdate! ]
//			case .Delete:
//				indexPathsToAnimate += [ updateItem.indexPathBeforeUpdate! ]
//			case .Move:
//				indexPathsToAnimate += [ updateItem.indexPathBeforeUpdate! ]
//				indexPathsToAnimate += [ updateItem.indexPathAfterUpdate! ]
//			default:
//				print("Unhandled collection view update item: \(updateItem)")
//			}
//		}
//	}
}
