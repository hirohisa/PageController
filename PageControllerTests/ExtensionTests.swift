//
//  ExtensionTests.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
import PageController

class ExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testViewControllerForCurrentPage() {

        let pageController = PageController()
        pageController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)

        let viewControllers = [
            UIViewController(),
            UIViewController(),
            UIViewController(),
        ]
        pageController.viewControllers = viewControllers
        pageController.viewDidLoad()
        pageController.reloadPages(AtIndex: 0)

        let result = pageController.viewControllerForCurrentPage()
        XCTAssertEqual(result!, viewControllers[0], "is failed")
    }

    func testSwapByIndex() {

        let array = NSArray(array: [0,1,2,3,4,5,6])
        var result: [Int] = []
        var valid: [Int] = []

        result = array.swapByIndex(0)
        valid  = [0,1,2,3,4,5,6]
        XCTAssertEqual(result, valid, "is failed")

        result = array.swapByIndex(1)
        valid  = [1,2,3,4,5,6,0]
        XCTAssertEqual(result, valid, "is failed")

        result = array.swapByIndex(5)
        valid  = [5,6,0,1,2,3,4]
        XCTAssertEqual(result, valid, "is failed")

        result = array.swapByIndex(10)
        valid  = []
        XCTAssertEqual(result, valid, "is failed")
    }

    func testFindMenuCells() {
        // TODO: Xcode6 -> sizes has same data, Xcode7GM -> sizes doesnt have same data
        return

        let menuBar = MenuBar()
        menuBar.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        var items = [String]()
        for i in 0 ..< 10 {
            items.append("-\(i)-")
        }
        menuBar.items = items

        var result: [MenuCell]!
        // asc

        result = menuBar.createMenuCells(from: 0, distance: 38, index: 0, asc: true)
        XCTAssertEqual(result.count, 1, "is failed")
        XCTAssertEqual(result[0].index, 0, "is failed")


        result = menuBar.createMenuCells(from: 0, distance: 39, index: 0, asc: true)
        XCTAssertEqual(result.count, 2, "is failed")
        XCTAssertEqual(result[0].index, 0, "is failed")
        XCTAssertEqual(result[1].index, 1, "is failed")

        result = menuBar.createMenuCells(from: 5, distance: 100, index: 3, asc: true)
        XCTAssertEqual(result.count, 3, "is failed")
        XCTAssertEqual(result[0].index, 3, "is failed")
        XCTAssertEqual(result[1].index, 4, "is failed")
        XCTAssertEqual(result[2].index, 5, "is failed")

        result = menuBar.createMenuCells(from: 5, distance: 100, index: 9, asc: true)
        XCTAssertEqual(result.count, 3, "is failed")
        XCTAssertEqual(result[0].index, 9, "is failed")
        XCTAssertEqual(result[1].index, 0, "is failed")
        XCTAssertEqual(result[2].index, 1, "is failed")

        result = menuBar.createMenuCells(from: 5, distance: 100, index: 10, asc: true)
        XCTAssertEqual(result.count, 3, "is failed")
        XCTAssertEqual(result[0].index, 0, "is failed")
        XCTAssertEqual(result[1].index, 1, "is failed")
        XCTAssertEqual(result[2].index, 2, "is failed")

        // desc

        result = menuBar.createMenuCells(from: 100, distance: 38, index: 9, asc: false)
        XCTAssertEqual(result.count, 1, "is failed")
        XCTAssertEqual(result[0].index, 9, "is failed")

        result = menuBar.createMenuCells(from: 100, distance: 39, index: 9, asc: false)
        XCTAssertEqual(result.count, 2, "is failed")
        XCTAssertEqual(result[0].index, 9, "is failed")
        XCTAssertEqual(result[1].index, 8, "is failed")

        result = menuBar.createMenuCells(from: 10, distance: 39, index: 9, asc: false)
        XCTAssertEqual(result.count, 2, "is failed")
        XCTAssertEqual(result[0].index, 9, "is failed")
        XCTAssertEqual(result[1].index, 8, "is failed")

        result = menuBar.createMenuCells(from: 5, distance: 100, index: 5, asc: false)
        XCTAssertEqual(result.count, 3, "is failed")
        XCTAssertEqual(result[0].index, 5, "is failed")
        XCTAssertEqual(result[1].index, 4, "is failed")
        XCTAssertEqual(result[2].index, 3, "is failed")

        result = menuBar.createMenuCells(from: 5, distance: 100, index: 1, asc: false)
        XCTAssertEqual(result.count, 3, "is failed")
        XCTAssertEqual(result[0].index, 1, "is failed")
        XCTAssertEqual(result[1].index, 0, "is failed")
        XCTAssertEqual(result[2].index, 9, "is failed")

        result = menuBar.createMenuCells(from: 5, distance: 100, index: 10, asc: false)
        XCTAssertEqual(result.count, 3, "is failed")
        XCTAssertEqual(result[0].index, 0, "is failed")
        XCTAssertEqual(result[1].index, 9, "is failed")
        XCTAssertEqual(result[2].index, 8, "is failed")

    }

    func testIndexesBetween() {

        var result: [Int]!
        var valid: [Int]!

        result = NSArray.indexesBetween(from: 0, to: 1, count:5, asc: true)
        valid = [0, 1]
        XCTAssertEqual(result, valid, "is failed")

        result = NSArray.indexesBetween(from: 1, to: 4, count:5, asc: true)
        valid = [1, 2, 3, 4]
        XCTAssertEqual(result, valid, "is failed")

        result = NSArray.indexesBetween(from: 1, to: 8, count:5, asc: true)
        valid = [1, 2, 3, 4, 0, 1, 2, 3]
        XCTAssertEqual(result, valid, "is failed")

        result = NSArray.indexesBetween(from: 3, to: 1, count:5, asc: true)
        valid = [3, 4, 0, 1]
        XCTAssertEqual(result, valid, "is failed")

        result = NSArray.indexesBetween(from: 1, to: 0, count:5, asc: false)
        valid = [1, 0]
        XCTAssertEqual(result, valid, "is failed")

        result = NSArray.indexesBetween(from: 4, to: 0, count:5, asc: false)
        valid = [4, 3, 2, 1, 0]
        XCTAssertEqual(result, valid, "is failed")
    }

    func testDistanceBetweenCells() {
        // TODO: Xcode6 -> sizes has same data, Xcode7GM -> sizes doesnt have same data
        return

        let menuBar = MenuBar()
        menuBar.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        var items = [String]()
        for i in 0 ..< 10 {
            items.append("-\(i)-") // frame = (0 0; 39 44)
        }
        menuBar.items = items

        var result: CGFloat!
        var valid: CGFloat!

        result = menuBar.distanceBetweenCells(from: 0, to: 1, asc: true)
        valid = 39
        XCTAssertEqual(result, valid, "is failed")

        result = menuBar.distanceBetweenCells(from: 2, to: 5, asc: true)
        valid = 39 * 3
        XCTAssertEqual(result, valid, "is failed")

        result = menuBar.distanceBetweenCells(from: 5, to: 2, asc: false)
        valid = 39 * 3
        XCTAssertEqual(result, valid, "is failed")

        result = menuBar.distanceBetweenCells(from: 1, to: -2, asc: false)
        valid = 39 * 3
        XCTAssertEqual(result, valid, "is failed")

    }

    func testRemoveIfExcluded() {

        var view: UIView!
        var frame: CGRect!
        var result: Bool!
        var valid: Bool!

        view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")


        view = UIView(frame: CGRect(x: 20, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")


        view = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")

        view = UIView(frame: CGRect(x: -20, y: 0, width: 50, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")


        view = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = true

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")


        view = UIView(frame: CGRect(x: 200, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = true

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")

        view = UIView(frame: CGRect(x: -200, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = true

        result = view.removeIfExcluded(frame: frame)
        XCTAssertEqual(result, valid, "is failed")
    }

    func testRelative() {

        var index: Int = 0
        var count: Int = 0
        var valid: Int = 0

        XCTAssertEqual(index.relative(count), valid, "is failed")

        index = 1
        count = 3
        valid = 1
        XCTAssertEqual(index.relative(count), valid, "is failed")

        index = 1
        count = 3
        valid = 1
        XCTAssertEqual(index.relative(count), valid, "is failed")

        index = 3
        count = 3
        valid = 0
        XCTAssertEqual(index.relative(count), valid, "is failed")

        index = -1
        count = 3
        valid = 2
        XCTAssertEqual(index.relative(count), valid, "is failed")

        index = -3
        count = 3
        valid = 0
        XCTAssertEqual(index.relative(count), valid, "is failed")

        index = -4
        count = 3
        valid = 2
        XCTAssertEqual(index.relative(count), valid, "is failed")

    }

    func testViewForCurrentPage() {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        var views = [UIView]()
        var result: UIView?
        var valid: UIView?

        result = scrollView.viewForCurrentPage()
        valid = nil
        XCTAssertTrue(result == valid, "result:\(result?.frame), valid:\(valid?.frame) is failed")


        scrollView.contentSize = CGSize(width: 300, height: 44)
        views = [
            UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44)),
            UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 44)),
            UIView(frame: CGRect(x: 200, y: 0, width: 100, height: 44)),
        ]

        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        refreshViewNearByCenter(scrollView, views: views)
        result = scrollView.viewForCurrentPage()
        valid = views[0]
        XCTAssertTrue(result == valid, "result:\(result?.frame), valid:\(valid?.frame) is failed")


        scrollView.contentSize = CGSize(width: 300, height: 44)
        views = [
            UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 44)),
            UIView(frame: CGRect(x: 50, y: 0, width: 50, height: 44)),
            UIView(frame: CGRect(x: 100, y: 0, width: 50, height: 44)),
            UIView(frame: CGRect(x: 150, y: 0, width: 50, height: 44)),
            UIView(frame: CGRect(x: 200, y: 0, width: 50, height: 44)),
            UIView(frame: CGRect(x: 250, y: 0, width: 50, height: 44)),
        ]
        refreshViewNearByCenter(scrollView, views: views)

        scrollView.contentOffset = CGPoint(x: 40, y: 0)
        result = scrollView.viewForCurrentPage()
        valid = views[1]
        XCTAssertTrue(result == valid, "result:\(result?.frame), valid:\(valid?.frame) is failed")

        scrollView.contentOffset = CGPoint(x: 50, y: 0)
        result = scrollView.viewForCurrentPage()
        valid = views[2]
        XCTAssertTrue(result == valid, "result:\(result?.frame), valid:\(valid?.frame) is failed")

        scrollView.contentOffset = CGPoint(x: 60, y: 0)
        result = scrollView.viewForCurrentPage()
        valid = views[2]
        XCTAssertTrue(result == valid, "result:\(result?.frame), valid:\(valid?.frame) is failed")
    }
}


extension ExtensionTests {

    func refreshViewNearByCenter(scrollView: UIScrollView, views: [UIView]) {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }

        for view in views {
            scrollView.addSubview(view)
        }
    }

}









