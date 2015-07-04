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
    }

    required init(coder aDecoder: NSCoder) {
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
    }

}

extension CustomViewController {

    func createViewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()

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

        for name in names {
            let viewController = ItemsCollectionViewController()
            viewController.title = name
            viewControllers.append(viewController)
        }

        return viewControllers
    }
}