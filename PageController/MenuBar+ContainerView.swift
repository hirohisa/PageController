//
//  MenuBar+ContainerView.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension MenuBar {

    class ContainerView: ScrollView {

        weak var bar: MenuBar?
        var visibledCells = [UIView]()

        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configure()
        }

        func configure() {
            isDirectionalLockEnabled = true
            clipsToBounds = false
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            scrollsToTop = false
            delegate = self
        }

        open override func layoutSubviews() {
            super.layoutSubviews()

            if frame.size == CGSize.zero {
                return
            }

            recenterIfNecessary()
        }
    }

}

// rendering

extension MenuBar.ContainerView {

    func recenterIfNecessary() {
        guard let bar = bar else { return }

        if needsRecenter() {
            recenter(relativeView: bar)
            render()
        }
    }

    func reloadData(at index: Int) {
        guard let bar = bar, let current = bar.createMenuBarCell(at: index) else {
            return
        }

        for cell in visibledCells {
            cell.removeFromSuperview()
        }

        if let cell = current as? MenuBarCellable {
            cell.setHighlighted(true)
        }

        addSubview(current)
        current.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        visibledCells = [current]
        render()
    }

    func render() {
        guard let bar = bar else { return }

        let frame = bar.frame

        let cells = visibledCells.filter { !$0.removeIfExcluded(bar.bounds) }

        var newCells = [UIView]()
        if let first = cells.first, let last = cells.last, let castedFirst = first as? MenuBarCellable, let castedLast = last as? MenuBarCellable {
            var distance = abs(first.frame.minX - frame.minX)
            newCells += bar.createMenuBarCells(first.frame.minX, distance: distance + bar.frame.width, index: castedFirst.index - 1, asc: false)
            distance = abs(last.frame.maxX - frame.maxX)
            newCells += bar.createMenuBarCells(last.frame.maxX, distance: distance + bar.frame.width, index: castedLast.index + 1, asc: true)
            for newCell in newCells {
                addSubview(newCell)
            }
        }

        visibledCells = (cells + newCells).sorted { $0.frame.origin.x < $1.frame.origin.x }
        for subview in visibledCells {
            if let cell = subview as? MenuBarCellable {
                cell.setHighlighted(cell.index == bar.selectedIndex)
            }
        }
    }
}

// touch

extension MenuBar.ContainerView {

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {
            let point = touch.location(in: self)
            for subview in subviews {
                if subview.frame.contains(point) {
                    let offset = CGPoint(x: subview.frame.minX - (frame.width - subview.frame.width) / 2, y: 0)
                    scrollOffsetTo(offset, animated: true)
                }
            }
        }
    }

}

// action

extension MenuBar.ContainerView {

    func userInteractionDidEnd() {
        guard let bar = bar, bar.isAutoSelectDidEndUserInteractionEnabled else { return }
        adjustCurrentPageToCenter()
    }

    func adjustCurrentPageToCenter(_ animated: Bool = true) {
        if let view = viewForCurrentPage(), let _ = view as? MenuBarCellable {
            let offset = CGPoint(x: view.frame.minX - (frame.width - view.frame.width) / 2, y: 0)
            scrollOffsetTo(offset, animated: animated)
        }
    }

    func scrollOffsetTo(_ offset: CGPoint, animated: Bool) {
        let duration = animated ? bar!.durationForAnimation : 0
        UIView.animate(withDuration: duration, animations: {
            self.contentOffset = offset
            }, completion: { _ in
                self.updateSubviews()
        })
    }

    func updateSubviews() {
        guard let view = viewForCurrentPage(), let current = view as? MenuBarCellable, let bar = bar else { return }
        bar.contentDidChangePage(AtIndex: current.index)
        render()
    }
}

extension MenuBar.ContainerView : UIScrollViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userInteractionDidEnd()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            userInteractionDidEnd()
        }
    }
}
