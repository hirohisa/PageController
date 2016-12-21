//
//  MenuCell.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/30/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

open class MenuCell: UIView {

    open let titleLabel = UILabel(frame: CGRect.zero)
    /**

    Margins between cells are zero, because it is difficult that calculating distance of scrolling. If you change margins between cell's labels, use constentInset.

    */
    open var contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) {
        didSet {
            updateContentInset()
        }
    }

    open var selected: Bool {
        return _selected
    }

    var _selected = false {
        didSet {
            updateData()
        }
    }
    open var backgroundView: UIView? {
        didSet {
            if let view = backgroundView {
                insertSubview(view, belowSubview: titleLabel)
            }
        }
    }
    open var selectedBackgroundView: UIView? {
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
    open func updateData() {
        backgroundView?.isHidden = selected
        backgroundView?.frame = bounds
        selectedBackgroundView?.isHidden = !selected
        selectedBackgroundView?.frame = bounds
    }

    open override var frame: CGRect {
        didSet {
            updateData()
        }
    }

    open var index = 0
}

extension MenuCell {

    enum Direction {
        case horizontal, vertical
    }

    func updateContentInset() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        removeConstraints(constraints)

        let newConstraints = makeConstraints(.horizontal) + makeConstraints(.vertical)
        addConstraints(newConstraints)
    }

    func makeConstraints(_ direction: Direction) -> [NSLayoutConstraint] {
        let views = ["view": titleLabel]
        switch direction {
        case .horizontal:
            return NSLayoutConstraint.constraints(withVisualFormat: constraintFormat(.horizontal), options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        case .vertical:
            return NSLayoutConstraint.constraints(withVisualFormat: constraintFormat(.vertical), options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        }
    }

    func constraintFormat(_ direction: Direction) -> String {
        switch direction {
        case .horizontal:
            return "H:|-\(contentInset.left)-[view]-\(contentInset.right)-|"
        case .vertical:
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
        titleLabel.textAlignment = .center
        updateContentInset()
    }
}
