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
    var protoCells: [MenuCell] = []

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

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public let scrollView = ContainerView(frame: CGRectZero)
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

        protoCells = createProtoCells()

        scrollView.reloadData()
        controller?.reloadPages(AtIndex: 0)
    }

    func createProtoCells() -> [MenuCell] {

        var menuCells = [MenuCell]()
        for index in 0 ..< items.count {
            let cell = createMenuCell(AtIndex: index)
            menuCells.append(cell)
        }

        return menuCells
    }

    func createMenuCell(AtIndex index: Int) -> MenuCell {
        let cell = menuCellClass(frame: frame)
        cell.titleLabel.text = items[index]
        cell.index = index
        cell.updateData()

        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let size = cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize, withHorizontalFittingPriority: 50, verticalFittingPriority: 50)
        // => systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        cell.frame = CGRect(x: 0, y: 0, width: size.width, height: frame.height)

        return cell
    }

    func revertToMove(AtIndex index: Int) {
        if let view = scrollView.viewForCurrentPage() as? MenuCell {

            if view.index > index || index - view.index == items.count - 1 {
                moveMinusOffsetUntilIndex(index: index)
            } else if view.index < index || view.index - index == items.count - 1 {
                movePlusOffsetUntilIndex(index: index)
            }
        }
    }

    func moveMinusOffsetUntilIndex(#index: Int) {

        if let view = scrollView.viewForCurrentPage() as? MenuCell {
            let distance = distanceBetweenCells(from: view.index, to: index, asc: false)

            let contentOffset = CGPoint(x: scrollView.contentOffset.x - distance, y: 0)
            UIView.animateWithDuration(durationForAnimation, animations: {
                self.scrollView.contentOffset = contentOffset
                }, completion: { _ in
                    self.scrollView.updateSubviews()
            })
        }
    }

    func movePlusOffsetUntilIndex(#index: Int) {

        if let view = scrollView.viewForCurrentPage() as? MenuCell {

            let distance = distanceBetweenCells(from: view.index, to: index, asc: true)

            let contentOffset = CGPoint(x: scrollView.contentOffset.x + distance, y: 0)
            UIView.animateWithDuration(durationForAnimation, animations: {
                self.scrollView.contentOffset = contentOffset
                }, completion: { _ in
                    self.scrollView.updateSubviews()
            })
        }
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