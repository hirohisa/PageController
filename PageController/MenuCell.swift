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
    /**

    Margins between cells are zero, because it is difficult that calculating distance of scrolling. If you change margins between cell's labels, use constentInset.

    */
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

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _configure()
    }

    /**

    If property cell's selected is changed, `updateData()` is called. You customize animations of activate to dis-activate, or dis-activate to activate, implement as override `updateData()`.

    */
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

    enum Direction {
        case Horizontal, Vertical
    }

    func updateContentInset() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        removeConstraints(constraints)

        let newConstraints = makeConstraints(.Horizontal) + makeConstraints(.Vertical)
        addConstraints(newConstraints)
    }

    func makeConstraints(direction: Direction) -> [NSLayoutConstraint] {
        let views = ["view": titleLabel]
        switch direction {
        case .Horizontal:
            return NSLayoutConstraint.constraintsWithVisualFormat(constraintFormat(.Horizontal), options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        case .Vertical:
            return NSLayoutConstraint.constraintsWithVisualFormat(constraintFormat(.Vertical), options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        }
    }

    func constraintFormat(direction: Direction) -> String {
        switch direction {
        case .Horizontal:
            return "H:|-\(contentInset.left)-[view]-\(contentInset.right)-|"
        case .Vertical:
            if contentInset.top == 0 && contentInset.bottom == 0 {
                return "V:|-[view]-|"
            } else if contentInset.top > 0 {
                return "V:|-\(contentInset.top)-[view]-|"
            }

            return "V:|-[view]-\(contentInset.bottom)-|"
        }
    }

    func _configure() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
        updateContentInset()
    }
}