//
//  CustomMenuBarCell.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 6/9/18.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import PageController

extension UIView {

    func fadeIn(duration: TimeInterval = 0.2) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration,
                       animations: {
                        self.alpha = 1
        }) { _ in }
    }

    func fadeOut(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { [weak self] finished in
            guard let weakSelf = self else { return }
            weakSelf.isHidden = true
            weakSelf.alpha = 1
        }
    }

}

class CustomMenuBarCell: UIView, MenuBarCellable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentMarkView: UIView!

    var index: Int = 0

    func setTitle(_ title: String) {
        titleLabel.text = title + "!!!"
    }

    func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if titleLabel.isHighlighted == highlighted { return }
//
//        if animated {
//            self.currentMarkView.alpha = 0
//            UIView.animate(withDuration: 1, animations: {
//                self.currentMarkView.alpha = 1
//            }, completion: { _ in
//            })
//        }
//
//        currentMarkView.isHidden = !highlighted
//        titleLabel.isHighlighted = highlighted
    }

    func prepareForUse() {
        currentMarkView.isHidden = true
        titleLabel.isHighlighted = false
    }

}
