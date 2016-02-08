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

    public enum ScrollType {
        case Half
        case Edge
    }

    public var scrollType: ScrollType = .Half

    public weak var delegate: PageControllerDelegate?

    public var menuBar: MenuBar = MenuBar(frame: CGRectZero)
    public var visibleViewController: UIViewController? {
        didSet {
            if let visibleViewController = visibleViewController {
                delegate?.pageController(self, didChangeVisibleController: visibleViewController, fromViewController: oldValue)
            }
        }
    }
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

extension PageController {

    public var frameForMenuBar: CGRect {
        var frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        if let frameForNavigationBar = navigationController?.navigationBar.frame {
            frame.origin.y = frameForNavigationBar.maxY
        }

        return frame
    }

    public var frameForContentController: CGRect {
        return view.bounds
    }

    var frameForLeftContentController: CGRect {
        var frame = frameForContentController
        frame.origin.x = 0
        return frame
    }

    var frameForCenterContentController: CGRect {
        var frame = frameForContentController
        frame.origin.x = frame.width
        return frame
    }

    var frameForRightContentController: CGRect {
        var frame = frameForContentController
        frame.origin.x = frame.width * 2
        return frame
    }

    func _configure() {
        automaticallyAdjustsScrollViewInsets = false

        let frame = frameForContentController
        scrollView.frame = frame
        scrollView.controller = self

        scrollView.contentSize = CGSize(width: frame.width * 3, height: frame.height)
        view.addSubview(scrollView)

        menuBar.frame = frameForMenuBar
        menuBar.controller = self
        view.addSubview(menuBar)

        scrollType = .Half
    }

    func _reloadData() {
        if !isViewLoaded() {
            return
        }

        menuBar.items = viewControllers.map { $0.title ?? "" }
    }

    public func reloadPages(AtIndex index: Int) {
        for viewController in childViewControllers {
            if viewController != viewControllers[index] {
                hideViewController(viewController)
            }
        }

        scrollView.contentOffset = frameForCenterContentController.origin
        loadPages(AtCenter: index)
    }

    public func switchPage(AtIndex index: Int) {

        if scrollView.dragging {
            return
        }

        guard let viewController = viewControllerForCurrentPage() else { return }

        let currentIndex = NSArray(array: viewControllers).indexOfObject(viewController)

        if currentIndex != index {
            reloadPages(AtIndex: index)
        }
    }

    func loadPages() {
        if let viewController = viewControllerForCurrentPage() {
            let index = NSArray(array: viewControllers).indexOfObject(viewController)
            loadPages(AtCenter: index)
        }
    }

    func loadPages(AtCenter index: Int) {
        if index >= viewControllers.count { return }
        let visibleViewController = viewControllers[index]
        if visibleViewController == self.visibleViewController { return }

        switchVisibleViewController(visibleViewController)
        // offsetX < 0 or offsetX > contentSize.width
        let frameOfContentSize = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        for viewController in childViewControllers {
            if viewController != visibleViewController && !viewController.view.include(frame: frameOfContentSize) {
                hideViewController(viewController)
            }
        }

        // center
        displayViewController(visibleViewController, frame: frameForCenterContentController)

        // left
        var exists = childViewControllers.filter { $0.view.include(frame: self.frameForLeftContentController) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index - 1).relative(viewControllers.count)], frame: frameForLeftContentController)
        }

        // right
        exists = childViewControllers.filter { $0.view.include(frame: self.frameForRightContentController) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index + 1).relative(viewControllers.count)], frame: frameForRightContentController)
        }
    }

    func switchVisibleViewController(viewController: UIViewController) {
        if visibleViewController != viewController {
            visibleViewController = viewController
        }
    }
}

extension PageController: UIScrollViewDelegate {

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        viewDidScroll()
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        viewDidScroll()
    }

}

extension PageController {

    func viewDidScroll() {
        guard let visibleViewController = visibleViewController else { return }

        if let viewController = viewControllerForNextPage() {

            let from = NSArray(array: viewControllers).indexOfObject(visibleViewController)
            let to = NSArray(array: viewControllers).indexOfObject(viewController)

            if viewController != visibleViewController {
                move(from: from, to: to)
                return
            }

            if !scrollView.tracking || !scrollView.dragging {
                return
            }
            if from == to {
                revert(to)
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
        menuBar.revert(to)
    }

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
