//
//  UseStoryboardContentViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 2018/08/23.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

class UseStoryboardContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .blue
        view.backgroundColor = .red
        print(#function)
        print(tableView.frame)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        print(tableView.frame)
        print(tableView.contentInset)
        print(tableView.contentOffset)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // XXX: index 0, set wrong frame size to tableView
        if #available(iOS 11.0, *) {} else {
            if tableView.frame != view.bounds {
                tableView.frame = view.bounds
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.label.text = String(indexPath.row)
        return cell
    }

}
