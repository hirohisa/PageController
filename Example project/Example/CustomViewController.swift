//
//  CustomViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 6/30/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import PageController

class CustomMenuCell: MenuCell {

    required init(frame: CGRect) {
        super.init(frame: frame)

        contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 1, right: 40)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateData() {
        super.updateData()

        titleLabel.textColor = selected ? UIColor.blackColor() : UIColor.grayColor()
    }
}

class CustomViewController: PageController {

    override func viewDidLoad() {
        super.viewDidLoad()

        menuBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        menuBar.registerClass(CustomMenuCell.self)
        viewControllers = createViewControllers()
        delegate = self
    }

}

extension CustomViewController {

    func createViewControllers() -> [UIViewController] {
        let names = [
            "Home",
            "Innovation",
            "Technology",
            "Life",
            "Bussiness",
            "Economics",
            "Financial",
            "Market",
        ]

        let viewControllers = names.map { name -> ItemsCollectionViewController in
            let viewController = ItemsCollectionViewController()
            viewController.title = name
            viewController.collectionView?.scrollsToTop = false
            return viewController
        }

        viewControllers.first?.collectionView?.scrollsToTop = true
        return viewControllers
    }
}

extension CustomViewController: PageControllerDelegate {

    func pageController(pageController: PageController, didChangeVisibleController visibleViewController: UIViewController, fromViewController: UIViewController) {
        print("now title is \(pageController.visibleViewController.title!)")
        print("did change from \(fromViewController.title!) to \(visibleViewController.title!)")

        for viewController in pageController.viewControllers {
            if let viewController = viewController as? ItemsCollectionViewController where viewController != visibleViewController {
                viewController.collectionView?.scrollsToTop = false
            }
        }
        if pageController.visibleViewController == visibleViewController {
            print("visibleViewController is assigned pageController.visibleViewController")
            if let viewController = visibleViewController as? ItemsCollectionViewController  {
                viewController.collectionView?.scrollsToTop = true
            }
        }
    }
}