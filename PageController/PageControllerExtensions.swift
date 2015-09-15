//
//  PageControllerExtensions.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

public extension PageController {

    func viewControllerForCurrentPage() -> UIViewController? {

        if let view = scrollView.viewForCurrentPage() {
            var responder: UIResponder? = view
            while responder != nil {
                if let responder = responder where responder is UIViewController {
                    return responder as? UIViewController
                }

                responder = responder?.nextResponder()
            }
        }

        return nil
    }

}

// TODO: swift 2.0 allows extensions to generic types, use Array

public extension NSArray {

    func swapByIndex<T>(index: Int) -> [T] {
        if index >= self.count {
            return []
        }

        var a = [T]()
        var b = [T]()

        var hit = false
        for (i, obj) in self.enumerate() {
            if i == index {
                hit = true
            }

            if hit {
                a.append(obj as! T)
            } else {
                b.append(obj as! T)
            }
        }

        return a + b
    }

    class func indexesBetween(from from: Int, to: Int, count: Int, asc: Bool) -> [Int] {
        var indexes = [Int]()

        var from = from
        var to = to

        if !asc {
            swap(&from, &to)
        }

        if from > to {
            to += count
        }

        for index in from ... to {
            indexes.append(index.relative(count))
        }

        if asc {
            return indexes
        }

        return Array(indexes.reverse())
    }
}

public extension MenuBar {

    func createMenuCells(from from: CGFloat, distance: CGFloat, index: Int, asc: Bool) -> [MenuCell] {
        if asc {
            return createMenuCellsByIncreasing(from: from, distance: distance, index: index)
        }

        return createMenuCellsByDecreasing(from: from, distance: distance, index: index)
    }

    func distanceBetweenCells(from from: Int, to: Int, asc: Bool) -> CGFloat {
        var indexes = NSArray.indexesBetween(from: from, to: to, count: items.count, asc: asc)

        indexes.removeAtIndex(0)

        return indexes.reduce(0) { (a: CGFloat, b: Int) -> CGFloat in a + self.sizes[b.relative(self.items.count)].width }
    }
}

extension MenuBar {

    func createMenuCellsByIncreasing(from from: CGFloat, distance: CGFloat, index: Int) -> [MenuCell] {
        var cells = [MenuCell]()

        var offsetX = from
        var index = index
        while offsetX <= from + distance {
            let size = sizes[index.relative(items.count)]
            let cell = createMenuCell(AtIndex: index.relative(items.count))
            cell.frame = CGRect(x: offsetX, y: 0, width: size.width, height: size.height)
            cells.append(cell)
            offsetX = cell.frame.maxX
            index++
        }

        return cells
    }

    func createMenuCellsByDecreasing(from from: CGFloat, distance: CGFloat, index: Int) -> [MenuCell] {
        var cells = [MenuCell]()

        var maxX = from
        var index = index
        while maxX >= from - distance {
            let size = sizes[index.relative(items.count)]
            let cell = createMenuCell(AtIndex: index.relative(items.count))
            cell.frame = CGRect(x: maxX - size.width, y: 0, width: size.width, height: size.height)
            cells.append(cell)
            maxX = cell.frame.minX
            index--
        }

        return cells
    }
}

public extension UIView {

    func include(frame frame: CGRect) -> Bool {
        return frame.contains(self.frame) || frame.intersects(self.frame)
    }

    func removeIfExcluded(frame frame: CGRect) -> Bool {
        if !include(frame: frame) {
            removeFromSuperview()
            return true
        }

        return false
    }
}

public extension Int {

    func relative(max: Int) -> Int {
        let denominator: Int = max != 0 ? max : 1
        var index = self % denominator
        if index < 0 {
            index = max - abs(index)
        }

        return index
    }
}

public extension UIViewController {

    func childViewControllerOrderedByX(asc asc: Bool) -> [UIViewController] {
        return childViewControllers.sort {
            if asc {
                return $0.view.frame.origin.x < $1.view.frame.origin.x
            }
            return $0.view.frame.origin.x > $1.view.frame.origin.x
        }
    }
}

public extension UIScrollView {

    func needsRecenter() -> Bool {

        let centerOffsetX = (contentSize.width - frame.width) / 2
        let distanceFromCenter = fabs(contentOffset.x - centerOffsetX)

        return distanceFromCenter >= bounds.width
    }

    func viewForCurrentPage() -> UIView? {
        let center = centerForVisibleFrame()
        return subviews.filter { $0.frame.contains(center) }.first
    }

    func centerForVisibleFrame() -> CGPoint {
        var center = contentOffset
        center.x += frame.width / 2
        center.y += frame.height / 2
        return center
    }

    func recenter(relativeView view: UIView) {
        let centerOffsetX = (contentSize.width - frame.width) / 2
        let currentOffset = contentOffset

        contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)

        for subview in subviews {
            var center = convertPoint(subview.center, toView: view)
            center.x += centerOffsetX - currentOffset.x
            subview.center = view.convertPoint(center, toView: self)
        }
    }
}