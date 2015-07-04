//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 6/24/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import PageController

class ViewController: PageController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = createViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController {

    func createViewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()

        let names = [
            "favorites",
            "recents",
            "contacts",
            "history",
            "more",
        ]

        for name in names {
            let viewController = ContentViewController()
            viewController.title = name
            viewControllers.append(viewController)
        }

        return viewControllers
    }
}