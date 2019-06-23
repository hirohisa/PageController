//
//  MenuBarCell.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/30/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol MenuBarCellable {
    var index: Int { get set }
    func setTitle(_ title: String)
    func setHighlighted(_ highlighted: Bool)
    // func setHighlighted(_ highlighted: Bool, animated: Bool)
    func prepareForUse()
}

class MenuBarCell: UIView, MenuBarCellable {

    public var index = 0
    let titleLabel = UILabel(frame: CGRect.zero)

    public required override init(frame: CGRect) {
        super.init(frame: frame)
        _configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _configure()
    }

    public func setTitle(_ title: String) {
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    public func setHighlighted(_ highlighted: Bool) {
    }

    public func prepareForUse() {
    }

    open override var frame: CGRect {
        didSet {
            prepareForUse()
        }
    }

    func makeConstraints() -> [NSLayoutConstraint] {
        let views = ["view": titleLabel]

        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[view]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
    }

    func updateContentInset() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        removeConstraints(constraints)

        addConstraints(makeConstraints())
    }

    func _configure() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        updateContentInset()
    }
}
