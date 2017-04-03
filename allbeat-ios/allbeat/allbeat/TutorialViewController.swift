
//
//  TutorialViewController.swift
//  allbeat
//
//  Created by Ari on 9/14/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
       
            self.storyboard?.instantiateViewController(withIdentifier: "FirstController")
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        

    }
  
    
       private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(color: "First"),
                self.newColoredViewController(color: "Second"),
                self.newColoredViewController(color: "Third"),
                self.newColoredViewController(color: "Fourth"),
                self.newColoredViewController(color: "Fifth")]
    }()
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)Controller")
    }
}
extension TutorialPageViewController: UIPageViewControllerDataSource {
    @objc(pageViewController:viewControllerAfterViewController:) func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }

}

