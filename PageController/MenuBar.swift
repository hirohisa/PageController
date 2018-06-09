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
    public var durationForAnimation: TimeInterval = 0.2

    public var items: [String] = [] {
        didSet {
            reloadData(atIndex: 0)
        }
    }
    var sizes: [CGSize] = []

    private var cellClass: UIView.Type?
    private var nib: UINib?

    public func register(_ cellClass: MenuBarCellable) {
        guard let cellClass = cellClass as? UIView.Type else { fatalError() }
        self.cellClass = cellClass
    }

    public func register(_ nib: UINib) {
        self.nib = nib
    }

    public var selectedIndex: Int {
        if let view = scrollView.viewForCurrentPage() as? MenuBarCellable {
            return view.index
        }

        return -1
    }

    public override var frame: CGRect {
        didSet {
            reloadData(atIndex: 0)
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

    public let scrollView = ContainerView(frame: CGRect.zero)
    fileprivate var animating = false
}

public extension MenuBar {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return scrollView
        }

        return super.hitTest(point, with: event)
    }
}

public extension MenuBar {

    func reloadData(atIndex index: Int) {
        menubar_configure()

        scrollView.reloadData(at: index)
        controller?.reloadPages(at: index)
    }

    func menubar_configure() {
        if items.count == 0 || frame == CGRect.zero {
            return
        }

        scrollView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width / 3, height: frame.height))
        scrollView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height)
        scrollView.contentOffset = CGPoint.zero

        sizes = measureCells()
    }

    func measureCells() -> [CGSize] {
        return items.enumerated().map { index, _ -> CGSize in
            return self.dequeueCell(at: index)!.frame.size
        }
    }

    func dequeueCell(at index: Int) -> UIView? {
        guard let cell = createCell(at: index) else { return nil }

        if var cell = cell as? MenuBarCellable {
            cell.setTitle(items[index])
            cell.index = index
            cell.prepareForReuse()
        }

        cell.updateConstraints()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let size = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize, withHorizontalFittingPriority: UILayoutPriority(rawValue: 50), verticalFittingPriority: UILayoutPriority(rawValue: 50))
        // => systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        cell.frame = CGRect(x: 0, y: 0, width: size.width, height: frame.height)

        return cell
    }

    func createCell(at index: Int) -> UIView? {
        if index >= items.count { return nil }

        if let nib = nib, let cell = nib.instantiate(withOwner: nil, options: nil).last as? UIView, let _ = cell as? MenuBarCellable {
            return cell
        }
        if let cellClass = cellClass {
            return cellClass.init(frame: frame)
        }

        return MenuCell(frame: frame)
    }

    func move(from: Int, until to: Int) {

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

    func revert(_ to: Int) {
        if let view = scrollView.viewForCurrentPage() as? MenuBarCellable {
            if view.index != to {
                move(from: view.index, until: to)
            }
        }
    }

    private func moveMinus(from: Int, until to: Int) {

        if let view = scrollView.viewForCurrentPage() as? MenuBarCellable {
            if view.index == to {
                return
            }
            if animating {
                return
            }
            animating = true

            let distance = distanceBetweenCells(from, to: to, asc: false)
            let diff = (sizes[from].width - sizes[to].width) / 2
            let x = scrollView.contentOffset.x - distance - diff

            let contentOffset = CGPoint(x: x, y: 0)
            UIView.animate(withDuration: durationForAnimation, animations: {
                self.scrollView.contentOffset = contentOffset
                }, completion: { _ in
                    self.completion()
            })
        }
    }

    private func movePlus(from: Int, until to: Int) {

        if let view = scrollView.viewForCurrentPage() as? MenuBarCellable {
            if view.index == to {
                return
            }
            if animating {
                return
            }
            animating = true

            let distance = distanceBetweenCells(from, to: to, asc: true)
            let diff = (sizes[from].width - sizes[to].width) / 2
            let x = scrollView.contentOffset.x + distance + diff

            let contentOffset = CGPoint(x: x, y: 0)
            UIView.animate(withDuration: durationForAnimation, animations: {
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
