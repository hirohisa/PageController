//
//  UseStoryboardViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 2018/08/23.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import PageController

class UseStoryboardViewController: PageController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = createViewControllers()
        menuBar.backgroundColor = .white
    }

    override var frameForMenuBar: CGRect {
        let frame = super.frameForMenuBar

        return CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 30)
    }

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

        let top = adjustedContentInsetTop
        let bottom: CGFloat
        if #available(iOS 11.0, *) {
            bottom = 0
        } else {
            bottom = tabBarController?.tabBar.frame.height ?? 0
        }
        let contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        let viewControllers = names.map { name -> UseStoryboardContentViewController in
            let viewController = UIStoryboard(name: "UseStoryboardContentViewController", bundle: nil).instantiateInitialViewController() as! UseStoryboardContentViewController
            viewController.title = name
            if viewController.view != nil {
                viewController.tableView?.scrollsToTop = false
                viewController.tableView?.contentInset = contentInset
            }
            return viewController
        }

        return viewControllers
    }
}
