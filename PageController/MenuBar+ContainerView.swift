//
//  MenuBar+ContainerView.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension MenuBar {

    public class ContainerView: UIScrollView {

        weak var bar: MenuBar?
        var visibledCells = [MenuCell]()

        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configure()
        }

        func configure() {
            directionalLockEnabled = true
            clipsToBounds = false
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            scrollsToTop = false
            delegate = self
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            if frame.size == CGSizeZero {
                return
            }

            recenterIfNecessary()
        }
    }

}

// rendering

extension MenuBar.ContainerView {

    func recenterIfNecessary() {
        if bar == nil {
            return
        }

        if needsRecenter() {
            recenter(relativeView: bar!)
            render()
        }
    }

    func reloadData() {
        for cell in visibledCells {
            cell.removeFromSuperview()
        }

        let cell = bar!.createMenuCell(AtIndex: 0)
        cell._selected = true
        addSubview(cell)
        cell.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        visibledCells = [cell]
        render()
    }

    func render() {
        if bar == nil {
            return
        }

        let frame = bar!.frame

        let cells = visibledCells.filter { !$0.removeIfExcluded(frame: self.bar!.bounds) }

        var newCells = [MenuCell]()
        if let first = cells.first, let last = cells.last {
            var distance = abs(first.frame.minX - frame.minX)
            newCells += bar!.createMenuCells(from: first.frame.minX, distance: distance + bar!.frame.width, index: first.index - 1, asc: false)
            distance = abs(last.frame.maxX - frame.maxX)
            newCells += bar!.createMenuCells(from: last.frame.maxX, distance: distance + bar!.frame.width, index: last.index + 1, asc: true)
            for newCell in newCells {
                addSubview(newCell)
            }
        }

        visibledCells = (cells + newCells).sort { $0.frame.origin.x < $1.frame.origin.x }
    }
}

// touch

extension MenuBar.ContainerView {

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if let touch = touches.first {
            let point = touch.locationInView(self)
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
        adjustCurrentPageToCenter()
    }

    func adjustCurrentPageToCenter(animated: Bool = true) {
        if let view = viewForCurrentPage() as? MenuCell {

            let offset = CGPoint(x: view.frame.minX - (frame.width - view.frame.width) / 2, y: 0)
            scrollOffsetTo(offset, animated: animated)
        }
    }

    func scrollOffsetTo(offset: CGPoint, animated: Bool) {
        let duration = animated ? bar!.durationForAnimation : 0
        UIView.animateWithDuration(duration, animations: {
            self.contentOffset = offset
            }, completion: { _ in
                self.updateSubviews()
        })
    }

    func updateSubviews() {
        if let view = viewForCurrentPage() as? MenuCell {
            for subview in subviews {
                if let subview = subview as? MenuCell {
                    subview._selected = (subview == view)
                }
            }
            bar?.contentDidChangePage(AtIndex: view.index)
        }
        render()
    }
}

extension MenuBar.ContainerView : UIScrollViewDelegate {

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        userInteractionDidEnd()
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            userInteractionDidEnd()
        }
    }
}