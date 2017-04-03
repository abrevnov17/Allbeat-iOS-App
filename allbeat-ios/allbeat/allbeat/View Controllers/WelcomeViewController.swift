//
//  WelcomeViewController.swift
//  allbeat
//
//  Created by Nathan Flurry on 12/8/15.
//  Copyright © 2015 allbeat, LLC. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
	// Definition and data holder for cell types
	enum CellType {
		case textbox(String /* Placeholder */), button(String /* Title */, Selector /* Action */)
	}
	
	// The different possible states inside the form
	var formState: [CellType] = [
		.textbox("username"),
		.button("continue", #selector(WelcomeViewController.continueTapped(_:)))
	]
	
	// Cell identifiers
	private let textboxCellId = "TextboxCell"
	private let buttonCellId = "ButtonCell"
	
	// Views
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var collectionView: UICollectionView!

	// Constraint
	@IBOutlet weak var headerHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set the initial state as unloaded and uninteractable
		adjustHeaderHeight(view.bounds.height)
		
		// Trigger the intro
		triggerIntro(1)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
	func triggerIntro(_ delay: TimeInterval = 0) {
		// The size to minimize the header to
		let minimizedHeaderHeight: CGFloat = 130
		UIView.animate(
			withDuration: 1.0,
			delay: delay,
			usingSpringWithDamping: 1.0,
			initialSpringVelocity: 0,
			options: UIViewAnimationOptions.layoutSubviews,
			animations: {
				// Adjust the header
				self.adjustHeaderHeight(minimizedHeaderHeight)
			},
			completion: nil
		)
	}
	
	func adjustHeaderHeight(_ height: CGFloat) {
		// Set the header size to the requested height
		headerHeight.constant = height
		headerView.setNeedsLayout()
		headerView.layoutIfNeeded()
		
		// Layout collection view, since header is changing heights
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
	}
	
	// The callback for when a button is pressed [temporary]
	func continueTapped(_ sender: UIButton) {
		moveToSignup()
	}
	
	// Adds the sign up info
	func moveToSignup() {
		collectionView.performBatchUpdates(
			{
				// Remove the continue button
				self.removeCellAtIndex(1)
				
				// Add the textboxes and buttons
				self.addCell(.textbox("email"))
				self.addCell(.textbox("confirm email"))
				self.addCell(.textbox("password"))
				self.addCell(.textbox("confirm password"))
				self.addCell(.button("sign up", #selector(WelcomeViewController.completeSignIn)))
			},
			completion: nil
		)
	}
	
	func completeSignIn() {
		performSegue(withIdentifier: "GoToMain", sender: self)
	}
}

extension WelcomeViewController {
	func addCell(_ cellType: CellType) {
		addCell(formState.count, cellType: cellType)
	}
	
	func addCell(_ index: Int, cellType: CellType) {
		// Remove the items from the data source
		formState.insert(cellType, at: index)
		
		// Remove from the collection view
		collectionView.insertItems(at: [ IndexPath(item: index, section: 0) ])
	}
	
	func removeCellAtIndex(_ index: Int) {
		// Remove the items from the data source
		formState.remove(at: index)
		
		// Remove from the collection view
		collectionView.deleteItems(at: [ IndexPath(item: index, section: 0) ])
	}
}

extension WelcomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return formState.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		//guard
        let item = indexPath.item /*else {
			print("Could not get item of index path \(indexPath).")
			return UICollectionViewCell()
		}*/
		
		let cellType = formState[item]
		
		switch cellType {
		case .textbox(let placeholder):
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextboxCell", for: indexPath) as! TextboxCollectionViewCell
			cell.placeholder = placeholder
			return cell
		case .button(let buttonTitle, let action):
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCollectionViewCell
			cell.title = buttonTitle
			cell.button.addTarget(self, action: action, for: .touchUpInside)
			return cell
		}
	}
}

extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		/*let cellType = getCellType(indexPath)!
		
		switch cellType {
		case .Textbox(_):
			return CGSize(width: collectionView.bounds.width, height: 60)
		case .Button(_, _):
			return CGSize(width: collectionView.bounds.width / 2, height: 60)
		}*/
		
		return CGSize(width: collectionView.bounds.width, height: 60)
	}
}
