//
//  ExtensionTests.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
@testable import PageController

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
        pageController.loadView()
        pageController.reloadPages(at: 0)

        let result = pageController.viewControllerForCurrentPage()
        XCTAssertEqual(result!, viewControllers[0])
    }

    func testFindMenuBarCells() {
        let menuBar = MenuBar()
        menuBar.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        var items = [String]()
        for _ in 0 ..< 10 {
            items.append("-a-")
        }
        menuBar.items = items
        menuBar.reloadData(atIndex: 0)

        var result: [MenuBarCellable]!
        // asc

        result = menuBar.createMenuBarCells(0, distance: 38, index: 0, asc: true) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].index, 0)


        result = menuBar.createMenuBarCells(0, distance: 50, index: 0, asc: true) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].index, 0)
        XCTAssertEqual(result[1].index, 1)

        result = menuBar.createMenuBarCells(5, distance: 100, index: 3, asc: true) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].index, 3)
        XCTAssertEqual(result[1].index, 4)
        XCTAssertEqual(result[2].index, 5)

        result = menuBar.createMenuBarCells(5, distance: 100, index: 9, asc: true) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].index, 9)
        XCTAssertEqual(result[1].index, 0)
        XCTAssertEqual(result[2].index, 1)

        result = menuBar.createMenuBarCells(5, distance: 100, index: 10, asc: true) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].index, 0)
        XCTAssertEqual(result[1].index, 1)
        XCTAssertEqual(result[2].index, 2)

        // desc

        result = menuBar.createMenuBarCells(100, distance: 38, index: 9, asc: false) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].index, 9)

        result = menuBar.createMenuBarCells(100, distance: 50, index: 9, asc: false) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].index, 9)
        XCTAssertEqual(result[1].index, 8)

        result = menuBar.createMenuBarCells(10, distance: 50, index: 9, asc: false) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].index, 9)
        XCTAssertEqual(result[1].index, 8)

        result = menuBar.createMenuBarCells(5, distance: 100, index: 5, asc: false) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].index, 5)
        XCTAssertEqual(result[1].index, 4)
        XCTAssertEqual(result[2].index, 3)

        result = menuBar.createMenuBarCells(5, distance: 100, index: 1, asc: false) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].index, 1)
        XCTAssertEqual(result[1].index, 0)
        XCTAssertEqual(result[2].index, 9)

        result = menuBar.createMenuBarCells(5, distance: 100, index: 10, asc: false) as! [MenuBarCellable]
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].index, 0)
        XCTAssertEqual(result[1].index, 9)
        XCTAssertEqual(result[2].index, 8)

    }

    func testDistanceBetweenCells() {
        let menuBar = MenuBar()
        menuBar.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        var items = [String]()
        for _ in 0 ..< 10 {
            items.append("-a-")
        }
        menuBar.items = items

        var result: CGFloat!
        var valid: CGFloat!

        let actual = menuBar.distanceBetweenMenuBarCells(0, to: 1, asc: true)
        XCTAssertNotEqual(actual, 0)

        result = menuBar.distanceBetweenMenuBarCells(2, to: 5, asc: true)
        valid = actual * 3
        XCTAssertEqual(result, valid)

        result = menuBar.distanceBetweenMenuBarCells(5, to: 2, asc: false)
        valid = actual * 3
        XCTAssertEqual(result, valid)

        result = menuBar.distanceBetweenMenuBarCells(1, to: -2, asc: false)
        valid = actual * 3
        XCTAssertEqual(result, valid)

    }

    func testRemoveIfExcluded() {

        var view: UIView!
        var frame: CGRect!
        var result: Bool!
        var valid: Bool!

        view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)


        view = UIView(frame: CGRect(x: 20, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)


        view = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)

        view = UIView(frame: CGRect(x: -20, y: 0, width: 50, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = false

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)


        view = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = true

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)


        view = UIView(frame: CGRect(x: 200, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = true

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)

        view = UIView(frame: CGRect(x: -200, y: 0, width: 100, height: 44))
        frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        valid = true

        result = view.removeIfExcluded(frame)
        XCTAssertEqual(result, valid)
    }

    func testRelative() {

        var index: Int = 0
        var count: Int = 0
        var valid: Int = 0

        XCTAssertEqual(index.relative(count), valid)

        index = 1
        count = 3
        valid = 1
        XCTAssertEqual(index.relative(count), valid)

        index = 1
        count = 3
        valid = 1
        XCTAssertEqual(index.relative(count), valid)

        index = 3
        count = 3
        valid = 0
        XCTAssertEqual(index.relative(count), valid)

        index = -1
        count = 3
        valid = 2
        XCTAssertEqual(index.relative(count), valid)

        index = -3
        count = 3
        valid = 0
        XCTAssertEqual(index.relative(count), valid)

        index = -4
        count = 3
        valid = 2
        XCTAssertEqual(index.relative(count), valid)

    }

    func testViewForCurrentPage() {
        let scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        var views = [UIView]()
        var result: UIView?
        var valid: UIView?

        result = scrollView.viewForCurrentPage()
        valid = nil
        XCTAssertTrue(result == valid)


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
        XCTAssertTrue(result == valid)


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
        XCTAssertTrue(result == valid)

        scrollView.contentOffset = CGPoint(x: 50, y: 0)
        result = scrollView.viewForCurrentPage()
        valid = views[2]
        XCTAssertTrue(result == valid)

        scrollView.contentOffset = CGPoint(x: 60, y: 0)
        result = scrollView.viewForCurrentPage()
        valid = views[2]
        XCTAssertTrue(result == valid)
    }
}


extension ExtensionTests {

    func refreshViewNearByCenter(_ scrollView: UIScrollView, views: [UIView]) {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }

        for view in views {
            scrollView.addSubview(view)
        }
    }

}









