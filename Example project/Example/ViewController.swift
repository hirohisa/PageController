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

}

extension ViewController {

    func createViewControllers() -> [UIViewController] {
        let names = [
            "favorites",
            "recents",
            "contacts",
            "history",
            "more",
        ]

        return names.map { name -> UIViewController in
            let viewController = ContentViewController()
            viewController.title = name
            return viewController
        }
    }
}
