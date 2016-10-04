//
//  MenuBarTests.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/29/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest
import PageController

class MenuBarTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testReload() {

        var menuBar: MenuBar!
        var view: MenuCell!

        menuBar = MenuBar(frame: CGRect.zero)
        menuBar.frame = CGRect(x: 0, y: 0, width: 300, height: 44)
        menuBar.items = ["1", "2", "3"]
        menuBar.reloadData(atIndex: 0)

        view = menuBar.scrollView.viewForCurrentPage() as! MenuCell
        XCTAssertEqual(view.index, 0, "is failed")

    }

    func testMoveMinus() {

        let expectation = self.expectation(description: "try move left to index")

        let menuBar = MenuBar(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
        var items = [String]()
        for index in 0 ..< 5 {
            items.append(index.description)
        }
        menuBar.items = items

        menuBar.reloadData(atIndex: 0)
        menuBar.layoutIfNeeded()
        XCTAssertEqual(menuBar.selectedIndex, 0, "is failed.")
        menuBar.move(from: 0, until: 3)

        let after = 0.3 * Double(NSEC_PER_SEC)
        let dispatchTime = DispatchTime.now() + Double(Int64(after)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            menuBar.layoutIfNeeded()
            XCTAssertEqual(menuBar.selectedIndex, 3, "is failed.")
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10, handler: { error in
            if let _ = error {
                XCTAssertTrue(false, "expectations are still finished")
            }
        })
    }

    func testMovePlus() {

        let expectation = self.expectation(description: "try move right to index")

        let menuBar = MenuBar(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
        var items = [String]()
        for index in 0 ..< 5 {
            items.append(index.description)
        }
        menuBar.items = items

        menuBar.reloadData(atIndex: 0)
        menuBar.layoutIfNeeded()
        XCTAssertEqual(menuBar.selectedIndex, 0, "is failed.")
        menuBar.move(from: 0, until: 3)

        let after = 0.3 * Double(NSEC_PER_SEC)
        let dispatchTime = DispatchTime.now() + Double(Int64(after)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            menuBar.layoutIfNeeded()
            XCTAssertEqual(menuBar.selectedIndex, 3, "is failed.")
            expectation.fulfill()
        })


        waitForExpectations(timeout: 10, handler: { error in
            if let _ = error {
                XCTAssertTrue(false, "expectations are still finished")
            }
        })
    }
}
