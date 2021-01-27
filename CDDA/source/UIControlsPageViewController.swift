//
//  UIControlsPageViewController.swift
//  Ratings
//
//  Created by Аполлов Юрий Андреевич on 25.01.2021.
//
import Foundation
import UIKit


class UIControlsPageViewController : UIPageViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewController("Default"),
            self.newViewController("Screen 1"),
//                self.newViewController("C3"),
        ]
    }()
    
    private func newViewController(_ name: String) -> UIViewController {
        return UIStoryboard(name: "UIControls", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
}

// MARK: UIPageViewControllerDataSource

extension UIControlsPageViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
// FIXME: on iPad buttons look bad. I believe the same is true for all non-notched devices.

// without pages count overlay looks better to me.
//    func presentationCount(for: UIPageViewController) -> Int {
//        return orderedViewControllers.count
//    }
//
//    func presentationIndex(for: UIPageViewController) -> Int {
//        guard let firstViewController = viewControllers?.first,
//              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
//            return 0
//        }
//
//        return firstViewControllerIndex
//    }
}
