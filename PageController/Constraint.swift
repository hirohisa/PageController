//
//  Constraint.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 8/11/18.
//  Copyright © 2018 Hirohisa Kawasaki. All rights reserved.
//

import Foundation

func makeConstraint(item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .equal) -> NSLayoutConstraint {
    let constaint = NSLayoutConstraint(
        item:       item,
        attribute:  attr,
        relatedBy:  relate,
        toItem:     to,
        attribute:  attrTo,
        multiplier: multiplier,
        constant:   constant
    )
    return constaint
}
