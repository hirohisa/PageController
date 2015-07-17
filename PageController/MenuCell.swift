//
//  MenuCell.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/30/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class MenuCell: UIView {

    public let titleLabel = UILabel(frame: CGRectZero)
    public var contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) {
        didSet {
            updateContentInset()
        }
    }

    public var selected: Bool {
        return _selected
    }

    var _selected = false {
        didSet {
            updateData()
        }
    }
    public var backgroundView: UIView? {
        didSet {
            if let view = backgroundView {
                insertSubview(view, belowSubview: titleLabel)
            }
        }
    }
    public var selectedBackgroundView: UIView? {
        didSet {
            if let view = selectedBackgroundView {
                insertSubview(view, belowSubview: titleLabel)
            }
        }
    }

    public required override init(frame: CGRect) {
        super.init(frame: frame)
        _configure()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _configure()
    }

    public func updateData() {
        backgroundView?.hidden = selected
        backgroundView?.frame = bounds
        selectedBackgroundView?.hidden = !selected
        selectedBackgroundView?.frame = bounds
    }

    public override var frame: CGRect {
        didSet {
            updateData()
        }
    }

    public var index = 0
}

extension MenuCell {

    func updateContentInset() {
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views: [NSObject : AnyObject] = ["view": titleLabel]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(contentInset.left)-[view]-\(contentInset.right)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
        addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(contentInset.top)-[view]-\(contentInset.bottom)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
        addConstraints(verticalConstraints)
    }

    func _configure() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
        updateContentInset()
    }
}