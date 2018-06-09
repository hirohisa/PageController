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
        pageController.loadView()

        XCTAssertNotEqual(pageController.view.frame, CGRect.zero)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[3],
            viewControllers[0],
            viewControllers[1],
        ]

        XCTAssertEqual(result, valid)

        pageController.reloadPages(at: 0)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[3],
            viewControllers[0],
            viewControllers[1],
        ]

        XCTAssertEqual(result, valid)
        XCTAssertEqual(result[0].view.frame.origin.x, 0)
        XCTAssertEqual(result[1].view.frame.origin.x, pageController.view.frame.width)
        XCTAssertEqual(result[2].view.frame.origin.x, pageController.view.frame.width * 2)

        pageController.reloadPages(at: 1)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[0],
            viewControllers[1],
            viewControllers[2],
        ]

        XCTAssertEqual(result, valid)
        XCTAssertEqual(result[0].view.frame.origin.x, 0)
        XCTAssertEqual(result[1].view.frame.origin.x, pageController.view.frame.width)
        XCTAssertEqual(result[2].view.frame.origin.x, pageController.view.frame.width * 2)

        pageController.reloadPages(at: 3)

        result = pageController.childViewControllerOrderedByX(true)
        valid = [
            viewControllers[2],
            viewControllers[3],
            viewControllers[0],
        ]

        XCTAssertEqual(result, valid)
        XCTAssertEqual(result[0].view.frame.origin.x, 0)
        XCTAssertEqual(result[1].view.frame.origin.x, pageController.view.frame.width)
        XCTAssertEqual(result[2].view.frame.origin.x, pageController.view.frame.width * 2)
    }

}
