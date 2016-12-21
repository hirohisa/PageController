//
//  ContentViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 6/24/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        let label = UILabel(frame: view.bounds)
        label.textAlignment = .center
        label.text = title
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
