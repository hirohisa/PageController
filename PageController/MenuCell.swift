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

    func _configure() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
        _addFittingConstraint(titleLabel)
    }

    public override var frame: CGRect {
        didSet {
            updateData()
        }
    }

    public var index = 0
}

// NSLayoutConstraint

extension MenuCell {

    func _addFittingConstraint(view: UIView) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views: [NSObject : AnyObject] = ["view": view]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
        addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views) as! [NSLayoutConstraint]
        addConstraints(verticalConstraints)
    }
}