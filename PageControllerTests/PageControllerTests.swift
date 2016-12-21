//
//  PageControllerTests.swift
//  PageControllerTests
//
//  Created by Hirohisa Kawasaki on 6/24/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
import PageController

class PageControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testReloadPages() {
        var result: [UIViewController]!
        var valid: [UIViewController]!

        let pageController = PageController()
        pageController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        let viewControllers = [
            UIViewController(),
            UIViewController(),
            UIViewController(),
            UIViewController(),
        ]
        pageController.viewControllers = viewControllers
        pageController.viewDidLoad()

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[3],
            viewControllers[0],
            viewControllers[1],
        ]

        XCTAssertEqual(result, valid, "is falied")
        XCTAssertEqual(result[0].view.frame.origin.x, 0, "is failed")
        XCTAssertEqual(result[1].view.frame.origin.x, 320, "is failed")
        XCTAssertEqual(result[2].view.frame.origin.x, 640, "is failed")

        pageController.reloadPages(AtIndex: 0)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[3],
            viewControllers[0],
            viewControllers[1],
        ]

        XCTAssertEqual(result, valid, "is falied")
        XCTAssertEqual(result[0].view.frame.origin.x, 0, "is failed")
        XCTAssertEqual(result[1].view.frame.origin.x, 320, "is failed")
        XCTAssertEqual(result[2].view.frame.origin.x, 640, "is failed")

        pageController.reloadPages(AtIndex: 1)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[0],
            viewControllers[1],
            viewControllers[2],
        ]

        XCTAssertEqual(result, valid, "is falied")
        XCTAssertEqual(result[0].view.frame.origin.x, 0, "is failed")
        XCTAssertEqual(result[1].view.frame.origin.x, 320, "is failed")
        XCTAssertEqual(result[2].view.frame.origin.x, 640, "is failed")

        pageController.reloadPages(AtIndex: 3)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[2],
            viewControllers[3],
            viewControllers[0],
        ]

        XCTAssertEqual(result, valid, "is falied")
        XCTAssertEqual(result[0].view.frame.origin.x, 0, "is failed")
        XCTAssertEqual(result[1].view.frame.origin.x, 320, "is failed")
        XCTAssertEqual(result[2].view.frame.origin.x, 640, "is failed")
    }

}
