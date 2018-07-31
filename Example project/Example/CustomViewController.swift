//
//  CustomViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 6/30/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import PageController

class CustomViewController: PageController {

    override func viewDidLoad() {
        super.viewDidLoad()

        menuBar.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        menuBar.register(UINib(nibName: "CustomMenuBarCell", bundle: nil))
        delegate = self
        viewControllers = createViewControllers()
    }

    override var frameForMenuBar: CGRect {
        let frame = super.frameForMenuBar

        return CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 60)
    }

}

extension CustomViewController {

    func createViewControllers() -> [UIViewController] {
        let names = [
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
        ]

        let top = menuBar.frame.maxY - 44 - 20 // navigationBar.height + statusBar.height
        let viewControllers = names.map { name -> ItemsCollectionViewController in
            let viewController = ItemsCollectionViewController()
            viewController.title = name
            viewController.collectionView?.scrollsToTop = false
            if var contentInset = viewController.collectionView?.contentInset {
                contentInset.top = top
                viewController.collectionView?.contentInset = contentInset
            }
            return viewController
        }

        viewControllers.first?.collectionView?.scrollsToTop = true
        return viewControllers
    }
}

extension CustomViewController: PageControllerDelegate {

    func pageController(_ pageController: PageController, didChangeVisibleController visibleViewController: UIViewController, fromViewController: UIViewController?) {
        print("now title is \(String(describing: pageController.visibleViewController?.title))")
        print("did change from \(String(describing: fromViewController?.title)) to \(String(describing: visibleViewController.title))")
        if pageController.visibleViewController == visibleViewController {
            print("visibleViewController is assigned pageController.visibleViewController")
        }

        if let viewController = fromViewController as? ItemsCollectionViewController  {
            viewController.collectionView?.scrollsToTop = false
        }
        if let viewController = visibleViewController as? ItemsCollectionViewController  {
            viewController.collectionView?.scrollsToTop = true
        }
    }
}
