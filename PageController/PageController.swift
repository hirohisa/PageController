//
//  PageController.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/24/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol PageControllerDelegate: class {

    func pageController(pageController: PageController, didChangeVisibleController visibleViewController: UIViewController, fromViewController: UIViewController?)
}

public class PageController: UIViewController {

    public weak var delegate: PageControllerDelegate?

    public var menuBar: MenuBar = MenuBar(frame: CGRectZero)
    public var visibleViewController: UIViewController!
    public var viewControllers: [UIViewController] = [] {
        didSet {
            _reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        _configure()
        _reloadData()
    }

    let scrollView = ContainerView(frame: CGRectZero)
}

public extension PageController {

    func frameForMenuBar() -> CGRect {
        var frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        if let frameForNavigationBar = navigationController?.navigationBar.frame {
            frame.origin.y = frameForNavigationBar.maxY
        }

        return frame
    }

    func frameForContentController() -> CGRect {
        return view.bounds
    }

}

extension PageController {

    func frameForLeftContentController() -> CGRect {
        var frame = frameForContentController()
        frame.origin.x = 0
        return frame
    }

    func frameForCenterContentController() -> CGRect {
        var frame = frameForContentController()
        frame.origin.x = frame.width
        return frame
    }

    func frameForRightContentController() -> CGRect {
        var frame = frameForContentController()
        frame.origin.x = frame.width * 2
        return frame
    }
}

extension PageController {

    func _configure() {
        automaticallyAdjustsScrollViewInsets = false

        let frame = frameForContentController()
        scrollView.frame = frame
        scrollView.controller = self

        scrollView.contentSize = CGSize(width: frame.width * 3, height: frame.height)
        view.addSubview(scrollView)

        menuBar.frame = frameForMenuBar()
        menuBar.controller = self
        view.addSubview(menuBar)
    }

    func _reloadData() {
        if !isViewLoaded() {
            return
        }

        menuBar.items = viewControllers.map { viewController -> String in
            return viewController.title ?? ""
        }
    }

    public func reloadPages(AtIndex index: Int) {
        for viewController in childViewControllers {
            if viewController != viewControllers[index] {
                hideViewController(viewController)
            }
        }

        scrollView.contentOffset = frameForCenterContentController().origin
        loadPages(AtCenter: index)
    }

    public func switchPage(AtIndex index: Int) {

        if scrollView.tracking || scrollView.dragging {
            return
        }

        if let viewController = viewControllerForCurrentPage() {
            let currentIndex = NSArray(array: viewControllers).indexOfObject(viewController)

            if currentIndex != index {
                reloadPages(AtIndex: index)
            }
        }
    }

    func loadPages() {
        if let viewController = viewControllerForCurrentPage() {
            let index = NSArray(array: viewControllers).indexOfObject(viewController)
            loadPages(AtCenter: index)
        }
    }

    func loadPages(AtCenter index: Int) {
        switchVisibleViewController(viewControllers[index])
        // offsetX < 0 or offsetX > contentSize.width
        let frameOfContentSize = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        for viewController in childViewControllers {
            if viewController != visibleViewController && !viewController.view.include(frame: frameOfContentSize) {
                hideViewController(viewController)
            }
        }

        // center
        displayViewController(visibleViewController, frame: frameForCenterContentController())

        // left
        var exists = childViewControllers.filter { $0.view.include(frame: self.frameForLeftContentController()) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index - 1).relative(viewControllers.count)], frame: frameForLeftContentController())
        }

        // right
        exists = childViewControllers.filter { $0.view.include(frame: self.frameForRightContentController()) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index + 1).relative(viewControllers.count)], frame: frameForRightContentController())
        }
    }

    func switchVisibleViewController(viewController: UIViewController) {
        if visibleViewController != viewController {
            let _visibleViewController = visibleViewController
            visibleViewController = viewController
            delegate?.pageController(self, didChangeVisibleController: viewController, fromViewController: _visibleViewController)
        }
    }
}

extension PageController: UIScrollViewDelegate {

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let viewController = viewControllerForCurrentPage() {
            let from = NSArray(array: viewControllers).indexOfObject(visibleViewController)
            let to = NSArray(array: viewControllers).indexOfObject(viewController)
            if viewController != visibleViewController {
                move(from: from, to: to)
            } else {
                if from == to {
                    revert(to)
                }
            }
        }
    }

    func move(from from: Int, to: Int) {
        let width = scrollView.frame.width
        if scrollView.contentOffset.x > width * 1.5 {
            menuBar.move(from: from, until: to)
        } else if scrollView.contentOffset.x < width * 0.5 {
            menuBar.move(from: from, until: to)
        }
    }

    func revert(to: Int) {
        if !scrollView.tracking || !scrollView.dragging {
            return
        }

        menuBar.revert(to)
    }
}

extension PageController {

    func displayViewController(viewController: UIViewController, frame: CGRect) {
        addChildViewController(viewController)
        viewController.view.frame = frame
        scrollView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }

    func hideViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(self)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
