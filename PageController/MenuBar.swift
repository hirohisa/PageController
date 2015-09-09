//
//  MenuBar.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/25/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class MenuBar: UIView {

    weak var controller: PageController?
    public var durationForAnimation: NSTimeInterval = 0.2

    public var items: [String] = [] {
        didSet {
            reloadData()
        }
    }
    var sizes: [CGSize] = []

    private var menuCellClass: MenuCell.Type = MenuCell.self
    public func registerClass(cellClass: MenuCell.Type) {
        menuCellClass = cellClass
    }

    public var selectedIndex: Int {
        if let view = scrollView.viewForCurrentPage() as? MenuCell {
            return view.index
        }

        return -1
    }

    public override var frame: CGRect {
        didSet {
            reloadData()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public let scrollView = ContainerView(frame: CGRectZero)
    private var animating = false
}

public extension MenuBar {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if pointInside(point, withEvent: event) {
            return scrollView
        }

        return super.hitTest(point, withEvent: event)
    }
}

public extension MenuBar {

    func reloadData() {
        if items.count == 0 || frame == CGRectZero {
            return
        }

        scrollView.frame = CGRect(origin: CGPointZero, size: CGSize(width: frame.width / 3, height: frame.height))
        scrollView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height)

        sizes = measureCells()

        scrollView.reloadData()
        controller?.reloadPages(AtIndex: 0)
    }

    func measureCells() -> [CGSize] {
        return items.enumerate().map { index, _ -> CGSize in
            let cell = self.createMenuCell(AtIndex: index)
            return cell.frame.size
        }
    }

    func createMenuCell(AtIndex index: Int) -> MenuCell {
        let cell = menuCellClass.init(frame: frame)
        cell.titleLabel.text = items[index]
        cell.index = index
        cell.updateData()
        cell.updateConstraints()

        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let size = cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize, withHorizontalFittingPriority: 50, verticalFittingPriority: 50)
        // => systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        cell.frame = CGRect(x: 0, y: 0, width: size.width, height: frame.height)

        return cell
    }

    func move(from from: Int, until to: Int) {

        if to - from == items.count - 1 {
            moveMinus(from: from, until: to)
        } else if from - to == items.count - 1 {
            movePlus(from: from, until: to)
        } else if from > to {
            moveMinus(from: from, until: to)
        } else if from < to {
            movePlus(from: from, until: to)
        }
    }

    func revert(to: Int) {
        if let view = scrollView.viewForCurrentPage() as? MenuCell {
            if view.index != to {
                move(from: view.index, until: to)
            }
        }
    }

    private func moveMinus(from from: Int, until to: Int) {

        if let view = scrollView.viewForCurrentPage() as? MenuCell {
            if view.index == to {
                return
            }
            if animating {
                return
            }
            animating = true

            let distance = distanceBetweenCells(from: from, to: to, asc: false)
            let diff = (sizes[from].width - sizes[to].width) / 2
            let x = scrollView.contentOffset.x - distance - diff

            let contentOffset = CGPoint(x: x, y: 0)
            UIView.animateWithDuration(durationForAnimation, animations: {
                self.scrollView.contentOffset = contentOffset
                }, completion: { _ in
                    self.completion()
            })
        }
    }

    private func movePlus(from from: Int, until to: Int) {

        if let view = scrollView.viewForCurrentPage() as? MenuCell {
            if view.index == to {
                return
            }
            if animating {
                return
            }
            animating = true

            let distance = distanceBetweenCells(from: from, to: to, asc: true)
            let diff = (sizes[from].width - sizes[to].width) / 2
            let x = scrollView.contentOffset.x + distance + diff

            let contentOffset = CGPoint(x: x, y: 0)
            UIView.animateWithDuration(durationForAnimation, animations: {
                self.scrollView.contentOffset = contentOffset
                }, completion: { _ in
                    self.completion()
            })
        }
    }

    private func completion() {
        animating = false
        scrollView.updateSubviews()
    }

    func contentDidChangePage(AtIndex index: Int) {
        controller?.switchPage(AtIndex: index)
    }

}

extension MenuBar {

    func configure() {
        clipsToBounds = true

        scrollView.bar = self
        addSubview(scrollView)
    }
}